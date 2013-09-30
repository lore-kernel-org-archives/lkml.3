Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3I3RLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:11:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26101 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3I3RLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:11:15 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-20-5249b0b2509f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] checkpatch: warn about incorrect __initdata placement
Date: Mon, 30 Sep 2013 19:11:02 +0200
Message-id: <5499012.hqsy0QJxyj@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1380556223.30647.10.camel@joe-AO722>
References: <1534354.yq7QTJSTju@amdc1032> <1380556223.30647.10.camel@joe-AO722>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd1NGzyDDE4/kLT4sFbDYvb9xywW
	Z5vesFtc3jWHzYHFY1ZDL5vHl1XXmD36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY/WiHqaC
	BoGKvRvmsDUwfuDpYuTkkBAwkejtu8MMYYtJXLi3nq2LkYtDSGARo8S606uYIJwWJolvE08w
	gVSxCVhJTGxfxdjFyMEhIqAocXcLP0iYWaBQYuGzjWAlwgJeEi27OllASlgEVCW+vIwBMXkF
	NCUuTpYDqRAV8JT4NGkp2FpOASOJYxfuMILYQgL+Etu2/gKbwisgKPFj8j0WiOnyEvv2T2WF
	sHUk9rdOY5vAKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcts+k
	djCubLA4xCjAwajEw2tQ7xkkxJpYVlyZe4hRgoNZSYR383KgEG9KYmVValF+fFFpTmrxIUZp
	DhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkZ2p4WPZ/Rt+H/gnG+XOKcky4TNx9R6jevu
	zfFm+bfRImxZX9z2qiAJlVz+PSozf0wWyDrxbv3TkDu6XAVfvyvZV2XblQqeX1k1c5/NzYVb
	FLplrrWuP33U37rmpHD3x9LtMhss7BgZv4mmm4i49t5LyTz278qbb9eWpVjE33jfcf+c3t+6
	m5eUWIozEg21mIuKEwE/WUzVVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, September 30, 2013 08:50:23 AM Joe Perches wrote:
> On Mon, 2013-09-30 at 15:23 +0200, Bartlomiej Zolnierkiewicz wrote:
> > __initdata tag should be placed between the variable name and equal
> > sign for the variable to be placed in the intended .init.data section.
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -4275,6 +4275,12 @@ sub process {
> []
> > +# check for incorrect __initdata placement
> > +		if ($line =~ /\bstruct\s+__initdata.*\=/) {
> > +			WARN("INITDATA_PLACEMENT",
> > +			     "__initdata tag should be placed between the variable name and equal sign\n" . $herecurr);
> > +		}
> 
> Hello Bartlomiej
> 
> I believe that -next commit 12de1c1ad0df
> ("checkpatch: add rules to check init attribute and const defects")
> 
> which adds $InitAttribute already does this test.
> 
> Anyway, this should be:
> 	if ($line =~ /\b(struct|union)\s+$InitAttribute.*=/) {
> 
> and please add this test adjacent to the other $InitAttribute
> tests only if it's not already covered by the first bit added
> by that commit below (again, I believe it is):
> 
> ------------------------
> 
> # check for bad placement of section $InitAttribute (e.g.: __initdata)
> 		if ($line =~ /(\b$InitAttribute\b)/) {
> 			my $attr = $1;
> 			if ($line =~ /^\+\s*static\s+(?:const\s+)?(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*[=;]/) {

It seems that a bit earlier patch which was merged for v3.12-rc1 (commit
8716de3 "checkpatch: add test for positional misuse of section specifiers
like __initdata" from September 11) already covers detection of the wrong
placement of __initdata (it was even inspired by the same EXYNOS4 code
issues as mine patch). I originally did my patch on August 30 so commit
8716de3 wasn't there yet, now it is all covered up nicely in the upstream.
Thanks for the work on this and sorry for the noise.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

