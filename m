Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab3AaEzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:55:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40176 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756953Ab3AaEzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:55:08 -0500
Message-ID: <1359608107.5255.5.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: fix USLEEP_RANGE test
From: Joe Perches <joe@perches.com>
To: Bruce Allan <bruce.w.allan@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Wed, 30 Jan 2013 20:55:07 -0800
In-Reply-To: <20130130191530.27127.49640.stgit@bwallan-smackover2.jf.intel.com>
References: <20130130191530.27127.49640.stgit@bwallan-smackover2.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 11:15 -0800, Bruce Allan wrote:
> Do not test udelay() for a value less than 10usec when passed a variable
> instead of a hard-coded number;
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -3237,9 +3237,9 @@ sub process {
[]
>  # prefer usleep_range over udelay
> -		if ($line =~ /\budelay\s*\(\s*(\w+)\s*\)/) {
> +		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
>  			# ignore udelay's < 10, however
> -			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
> +			if (! ($1 < 10) ) {
>  				CHK("USLEEP_RANGE",
>  				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
>  			}

Thanks Bruce.

Just a trivial comment:

Maybe this would be a little neater as

		if ($line =~ \budelay\s*\(\s*(\d+)\s*\) &&
		    $1 >= 10) {
			CHK(etc...)
		}

No worries though.

