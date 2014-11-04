Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaKDHH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:07:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaKDHHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:07:54 -0500
Message-ID: <54587B47.2080309@suse.de>
Date: Tue, 04 Nov 2014 08:07:51 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Elliott <elliott@hp.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build failure after merge of the scsi tree
References: <20141104154320.2919bf64@canb.auug.org.au>
In-Reply-To: <20141104154320.2919bf64@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------060201010503000500010204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060201010503000500010204
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/04/2014 05:43 AM, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (arm 
> multi_v7_defconfig) failed like this:
> 
> In file included from include/linux/sched.h:17:0, from
> include/linux/blkdev.h:4, from drivers/scsi/constants.c:10: 
> drivers/scsi/constants.c: In function 'scsi_opcode_sa_name': 
> include/linux/kernel.h:54:32: error: invalid application of
> 'sizeof' to incomplete type 'const char *[]' #define
> ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> __must_be_array(arr)) ^ drivers/scsi/constants.c:300:15: note:
> in expansion of macro 'ARRAY_SIZE' if (opcode <
> ARRAY_SIZE(cdb_byte0_names)) ^
> 
> Caused by 94bafab0008c ("scsi: consolidate opcode lookup in 
> scsi_opcode_sa_name()").  This build does not have 
> CONFIG_SCSI_CONSTANTS set.
> 
> I have used the scsi tree from next-20141031 again (since
> yesterday's tree had a different build problem).
> 
Sorry. Here's the patch.

Cheers,

Hannes
- -- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUWHtHAAoJEGz4yi9OyKjPfdgP+wZweCbK1HJ7PBz8CCqT6n6d
HDOv0oX4Ia3Oo53NhdIAD9745sCWWegSBYZf7C/gTXVtmBxJ30NnuI+Cg0otaTHA
DPJZ26mBCNijYvpVGqgcSkXRdQQMiBGo6TLmsdpXxn4NFuh3IoRS+8gMgEFxpQdK
aAsHnRBTbfaeYpuNR2P5IJVc1L89rg3DkLWMw3ybSO5WzAcjg4yDiasCsGNHq/T4
e9t+V7/+YA14UOMAHfsAnD/B7UI/7B0ealDbepr/cq1NdJ1F0G7JoCS0yAExRumv
3KBznE29YMZTXCqJg6DNQqkV1xmuB2l2/eAZrM/pHTHGWBQk27WI/KsmqISt9Vb+
vmowDuJQNwZG784KSmbRcjSnuNTIltUybhgF/r+m3dNq4j+H/SroBIi5xI+5HJR+
m7G0tjQkpI3Hie3kf9Egwj09goMZ5ka8tIETMqgJFa2AZ3VpnBekxXGe1OtFgfeo
3nOCnYNNADUSIFUmGmAUusPlgFyMGoWvTHs+koYN8cS+q+X9WJgI3mihnMuiVIux
jG2W7IDCimiss/g0Bnol7M7FdL4QMVeg9/LX5wIl2G1b9Nz4ZDCSI/ooHL+xMFrm
H1wwBF9/xjpc0J6RWimkSvFa4iRCti4Ac8w41l+APwEtH2mWdrefTaadV0JXH/wh
brJGtCQhTrCLGuyLluPx
=xaoW
-----END PGP SIGNATURE-----

--------------060201010503000500010204
Content-Type: text/x-patch;
 name="0001-scsi-Fixup-compilation-warning-when-SCSI_CONSTANTS-i.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi-Fixup-compilation-warning-when-SCSI_CONSTANTS-i.pa";
 filename*1="tch"

>From 355eac426aea2e1f98b99a41707b37e9ba3ef02b Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 4 Nov 2014 08:06:03 +0100
Subject: [PATCH] scsi: Fixup compilation warning when SCSI_CONSTANTS is not
 set

ARRAY_SIZE() requires the array to actually have a size.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index b3cbf3a..a1a7fca 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -267,7 +267,7 @@ static struct sa_name_list sa_names_arr[] = {
 };
 
 #else /* ifndef CONFIG_SCSI_CONSTANTS */
-static const char *cdb_byte0_names[];
+static const char *cdb_byte0_names[0];
 
 static struct sa_name_list sa_names_arr[] = {
 	{VARIABLE_LENGTH_CMD, NULL, 0},
-- 
1.8.5.2


--------------060201010503000500010204--
