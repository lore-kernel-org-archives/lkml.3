Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3ENQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:59:16 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57418 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab3ENQ7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:59:14 -0400
Message-ID: <51926CB6.7050703@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 09:56:22 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: avoid warning on page flag acessors
References: <1368549951-1170-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1368549951-1170-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051416-9360-0000-0000-0000122A1C3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 09:45 AM, Cody P Schafer wrote:
> Using Page*() triggers a camelcase warning, but shouldn't.
>
> Introduced by be987d9f80354e2e919926349282facd74992f90, which added the
> other Page flag users.
>
> Pipe ('|') at the end of a grouping doesn't cause the grouping to match
> an emtpy string, use ? after the grouping instead to get the desired
> behavior.
>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>   scripts/checkpatch.pl | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b954de5..ee24026 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2939,7 +2939,7 @@ sub process {
>   			my $var = $1;
>   			if ($var !~ /$Constant/ &&
>   			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> -			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
> +			    $var !~ /"^(?:Clear|Set|TestClear|TestSet)?Page[A-Z]/ &&
>   			    !defined $camelcase{$var}) {
>   				$camelcase{$var} = 1;
>   				WARN("CAMELCASE",
>


Nix this, appears to still be broken

	WARNING: Avoid CamelCase: <PageBuddy>
	#51: FILE: mm/page_alloc.c:449:
	+	VM_BUG_ON(!PageBuddy(page));
	
	total: 0 errors, 1 warnings, 46 lines checked
	
	/home/cody/mm/0008-page_alloc-add-return_pages_to_zone-when-DYNAMIC_NUM.patch has style problems, please review.

