Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaCMQIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:08:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52814 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbaCMQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:08:42 -0400
Date: Thu, 13 Mar 2014 16:05:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 3/7] ftrace: Add arm64 support to recordmcount
Message-ID: <20140313160534.GC25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-4-git-send-email-takahiro.akashi@linaro.org>
 <20140313123819.GF12331@mudshark.cambridge.arm.com>
 <5321C776.30208@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5321C776.30208@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 02:57:58PM +0000, AKASHI Takahiro wrote:
> On 03/13/2014 09:38 PM, Will Deacon wrote:
> > On Thu, Mar 13, 2014 at 10:13:46AM +0000, AKASHI Takahiro wrote:
> >> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> >> index 91280b8..397b6b8 100755
> >> --- a/scripts/recordmcount.pl
> >> +++ b/scripts/recordmcount.pl
> >> @@ -279,6 +279,11 @@ if ($arch eq "x86_64") {
> >>       $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24|THM_CALL)" .
> >>   			"\\s+(__gnu_mcount_nc|mcount)\$";
> >>
> >> +} elsif ($arch eq "arm64") {
> >> +    $alignment = 3;
> >> +    $section_type = '%progbits';
> >> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_AARCH64_CALL26\\s+_mcount\$";
> >
> > What about "mcount" (i.e. no underscore)?
> 
> I don't think it works since such regex doesn't match to "CALL26   _mcount".

What I meant was, do you need to match "mcount" as well? However, after
speaking to our GCC guys, they say they only support "_mcount" (preferred)
and "__mcount" (which GCC itself doesn't emit) so you can leave this regex
as-is.

Will
