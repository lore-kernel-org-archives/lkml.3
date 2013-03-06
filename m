Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3CFJcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:32:19 -0500
Received: from smtp-out.abv.bg ([194.153.145.80]:46555 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab3CFJcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:32:15 -0500
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=A9pkDFp6IIZtPtrmx0aXIdALpV51vG6bkJ870kjoIBI8zZH2Qb17dOCGDucBzrtEU
	RUva+GSKgzvq5COSPrhiAWZAQiYwF1/GPjnjH94yCrZ6hT/N15BiIb+k4Th9ayUTKN/
	RTJW3g6IaQIcWiE5CfG/g+MTbvV8GhRAlIP1YSI=
Date: Wed, 6 Mar 2013 11:32:12 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: pdeschrijver@nvidia.com, pali.rohar@gmail.com, tony@atomide.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <107742828.129755.1362562332955.JavaMail.apache@mail81.abv.bg>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 92.247.16.98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 




 >-------- Оригинално писмо --------
 >От:  Aaro Koskinen 
 >Относно: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
 >До: Ивайло Димитров 
 >Изпратено на: Събота, 2013, Март 2 01:51:39 EET
 >
 >
 >On Fri, Mar 01, 2013 at 12:09:12PM +0200, Ивайло Димитров wrote:
 >> Unfortunately it is necessary, on RX-51 PPA/NOLO leaves IBE bit unset.
 >
 >You sure? I think you need to explain this more - the commit message in
 >the original patch is empty/missing...
 >
 >A.
 >

Yes, I am sure, NOLO leaves IBE bit in ACR unset, I've verified that by reading/printing the contents of ACR from both u-boot and the kernel itself. With IBE bit unset, "mcr p15, 0, rX, c7, c5, 6" - flush BTAC/BTB instruction(which is needed to workaround errata 430973) is a noop.

Yes, I am sure, IBE but must be set by using a call to PPA, on RX-51 setting that bit from the kernel (as it is done in the "ARM errata: Stale prediction on replaced interworking branch" kernel patch, see http://kerneltrap.org/mailarchive/git-commits-head/2009/5/3/5622724) does not work, see the comment at the end: "Note that setting specific bits in the ACTLR register may not be available in non-secure mode.". This is exactly the case for RX-51. I've verified that too.

If you need anything else elaborated on, I'm fine, just ask :)


Regards,
Ivo
