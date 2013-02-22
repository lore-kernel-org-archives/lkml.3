Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3BVWVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:21:11 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44099 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756939Ab3BVWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:21:08 -0500
Message-ID: <1361571667.2030.13.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Improve CamelCase test for Page
From: Joe Perches <joe@perches.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Feb 2013 14:21:07 -0800
In-Reply-To: <1361570508.5608.10.camel@thor.lan>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
	 <1361566784.2030.6.camel@joe-AO722> <1361570508.5608.10.camel@thor.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 17:01 -0500, Peter Hurley wrote:
> I didn't bother to mention it before, but since your addressing mm
> CamelCase exceptions, perhaps
> 
>   xxxx_XXXX
>   xx_XXX_xxx
>   XXX_xxx
> 
> could be exceptions as well?

Maybe the check should only be for "[A-Z][a-z]|[a-z][A-Z]"
to make '_' and any non-alpha char a name barrier.

So vars like A_foo or b_9A would be acceptable.

Maybe:

---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 747bcd7..e08e9f6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2929,8 +2929,8 @@ sub process {
 		while ($line =~ m{($Constant|$Lval)}g) {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
-			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
-			    $var !~ /^Page[A-Z]/ &&
+			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
+			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ && &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",


