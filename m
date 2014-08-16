Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaHPVTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:19:16 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62534 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaHPVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140813170639.GB1869@nanopsycho.orion>
References: <1407784696-31698-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140813170639.GB1869@nanopsycho.orion>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat, 16 Aug 2014 23:18:54 +0200
Message-ID: <CAFo99gZXrgn7SZsS+GYXrf65JcfwuCP-qej08yQCs5Z0g3e2rA@mail.gmail.com>
Subject: Re: [PATCH V2] net: ethernet: myricom: myri10ge: myri10ge.c: Cleaning
 up missing null-terminate after strncpy call
To: Jiri Pirko <jiri@resnulli.us>
Cc: Hyong-Youb Kim <hykim@myri.com>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-13 19:06 GMT+02:00 Jiri Pirko <jiri@resnulli.us>:
> Mon, Aug 11, 2014 at 09:18:16PM CEST, rickard_strandqvist@spectrumdigital.se wrote:
>>Added a guaranteed null-terminate after call to strncpy.
>>
>>Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>---
>> drivers/net/ethernet/myricom/myri10ge/myri10ge.c |    1 +
>> 1 file changed, 1 insertion(+)
>>
>>diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
>>index f3d5d79..69c26f0 100644
>>--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
>>+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
>>@@ -574,6 +574,7 @@ myri10ge_validate_firmware(struct myri10ge_priv *mgp,
>>
>>       /* save firmware version for ethtool */
>>       strncpy(mgp->fw_version, hdr->version, sizeof(mgp->fw_version));
>>+      mgp->fw_version[sizeof(mgp->fw_version) - 1] = '\0';
>
>         Why not to use strlcpy?
>
>>
>>       sscanf(mgp->fw_version, "%d.%d.%d", &mgp->fw_ver_major,
>>              &mgp->fw_ver_minor, &mgp->fw_ver_tiny);
>>--
>>1.7.10.4


Hi

Sure, strlcpy is preferable in many ways if we only can guarantee that
it is safe.
I have seldom received so much criticism when I start switching to
strlcpy, although much of it was justified :)
Even Linus was getting into the debate.  See more:

https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5


I change to strlcpy only when I'm sure it will not cause any other problems.
But if you or anyone else can guarantee that in this case, so I'd make
a new patch with strlcpy.


Kind regards

Rickard Strandqvist
