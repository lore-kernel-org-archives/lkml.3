Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3CBNH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:07:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45904 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752038Ab3CBNHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:07:54 -0500
Message-ID: <1362229674.2254.5.camel@joe-AO722>
Subject: Re: checkpatch bailing out
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 05:07:54 -0800
In-Reply-To: <5131EA60.40607@broadcom.com>
References: <5131EA60.40607@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 13:02 +0100, Arend van Spriel wrote:
> With my laptop being broken I have to work on a server provided by my 
> employer and I am preparing some patches for submission. So I intended 
> to run checkpatch, but I get the following message after which the 
> script bails out:
> 
> $ git format-patch -1 --stdout | scripts/checkpatch.pl -
> Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- 
> HERE |(?-1))*\))/ at scripts/checkpatch.pl line 347.
> 
> The server runs RHEL5
> 
> 2.6.18-308.20.1.el5 #1 SMP x86_64 GNU/Linux
> 
> Perl interpreter:
> 
> $ /usr/bin/perl -v
> 
> This is perl, v5.8.8 built for x86_64-linux-thread-multi
> 
> My repository is based on wireless-testing repo.
> 
> Did a quick search on LKML, but not finding anything like this. Any help 
> would be appreciated here.

Sorry, I don't have perl 5.8.8, it's pretty old.

Perhaps this explains it:
http://www.perlmonks.org/?node_id=971814 (question)
http://www.perlmonks.org/?node_id=971883 (explanation)

Perhaps you could test this patch?
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..fb53845 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -344,7 +344,7 @@ our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
 # requires at least perl version v5.10.0
 # Any use must be runtime checked with $^V
 
-our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
+our $balanced_parens = qr/(\((?:(?>[^\(\)]+)|(?-1))*\))/;
 our $LvalOrFunc	= qr{($Lval)\s*($balanced_parens{0,1})\s*};
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 


