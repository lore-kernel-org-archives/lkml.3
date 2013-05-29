Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840Ab3E2LYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:24:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42886 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965525Ab3E2LYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:24:13 -0400
Message-ID: <1369826652.22004.106.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: forgive use of mixed case variables
 measuring units
From: Joe Perches <joe@perches.com>
To: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Wed, 29 May 2013 04:24:12 -0700
In-Reply-To: <1369825370-31901-1-git-send-email-phil.carmody@partner.samsung.com>
References: <1369825370-31901-1-git-send-email-phil.carmody@partner.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 14:02 +0300, Phil Carmody wrote:
> I don't think anyone really has an issue with things like max_mV.
> And whilst nS et al. may not be SI standard, at least it's clear
> what they represent.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2940,6 +2940,7 @@ sub process {
>  			if ($var !~ /$Constant/ &&
>  			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
>  			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
> +			    $var !~ /^[a-z_]*_[numk][VAS]$/ &&
>  			    !defined $camelcase{$var}) {
>  				$camelcase{$var} = 1;
>  				WARN("CAMELCASE",

Hi Phil.

CamelCase was downgraded to a --strict only (CHK)
test in -next recently.  commit f0e8102413
("checkpatch: change CamelCase test and make it --strict")

I'm hesitant to add a longish whitelist inside
checkpatch itself, but if it's added, it should
probably be an array.


