Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbbAWUHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:07:41 -0500
Received: from mail.atsec.com ([195.30.99.214]:37170 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbbAWUHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:07:38 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2015 15:07:38 EST
From: Stephan Mueller <smueller@atsec.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto/testmgr: mark rfc4106(gcm(aes)) as fips_allowed
Date: Fri, 23 Jan 2015 20:58:18 +0100
Message-ID: <47404663.9NCU8GY7rF@tauon>
Organization: atsec information security GmbH
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1422034935-25537-1-git-send-email-jarod@redhat.com>
References: <1422034935-25537-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 23. Januar 2015, 12:42:15 schrieb Jarod Wilson:

Hi Jarod,

>This gcm variant is popular for ipsec use, and there are folks who
>would like to use it while in fips mode. Mark it with fips_allowed=1
>to facilitate that.

Acked-by: Stephan Mueller <smueller@atsec.com>

For the records: this change is ok as the RFC4106 "wrapper" only 
massages the input data like IV or keys without changing the 
cryptographic logic of GCM. As the basic cipher is not changed allowing 
RFC4106 is harmless with respect to FIPS 140-2 to use and apply this 
RFC4106 wrapper. This implies that the RFC4106 wrapper can be used in 
FIPS mode.
>
>CC: LKML <linux-kernel@vger.kernel.org>
>CC: Stephan Mueller <smueller@atsec.com>
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> crypto/testmgr.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>index 235b1ff..758d028 100644
>--- a/crypto/testmgr.c
>+++ b/crypto/testmgr.c
>@@ -3293,6 +3293,7 @@ static const struct alg_test_desc
>alg_test_descs[] = { }, {
> 		.alg = "rfc4106(gcm(aes))",
> 		.test = alg_test_aead,
>+		.fips_allowed = 1,
> 		.suite = {
> 			.aead = {
> 				.enc = {


Ciao
Stephan


