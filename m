Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3ENRNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:13:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35684 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194Ab3ENRNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:13:19 -0400
Message-ID: <1368551598.23335.4.camel@joe-AO722>
Subject: Re: [PATCH v2] checkpatch: avoid warning on page flag acessors
From: Joe Perches <joe@perches.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 14 May 2013 10:13:18 -0700
In-Reply-To: <1368551211-6213-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368549951-1170-1-git-send-email-cody@linux.vnet.ibm.com>
	 <1368551211-6213-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[]On Tue, 2013-05-14 at 10:06 -0700, Cody P Schafer wrote:
> Using Page*() triggers a camelcase warning, but shouldn't.
> 
> be987d9f80354e2e919926349282facd74992f90 added a spurious '"' (double
> quote) breaking the regex.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2939,7 +2939,7 @@ sub process {
>  			my $var = $1;
>  			if ($var !~ /$Constant/ &&
>  			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> -			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
> +			    $var !~ /"^(?:Clear|Set|TestClear|TestSet)?Page[A-Z]/ &&

I think you need to delete the ", leave the | and remove the ?
Dunno where that " came from.


