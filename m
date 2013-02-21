Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3BUSmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:42:36 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56642 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab3BUSme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:42:34 -0500
Date: Wed, 20 Feb 2013 23:32:31 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: update top level 00-INDEX file with new
 additions
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <512391DA.6090706@windriver.com> (from
	paul.gortmaker@windriver.com on Tue Feb 19 08:53:14 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361424751.29465.11@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 08:53:14 AM, Paul Gortmaker wrote:
> On 13-02-18 10:57 AM, Randy Dunlap wrote:
> > On 02/18/13 01:39, Jiri Kosina wrote:
> >> On Thu, 14 Feb 2013, Paul Gortmaker wrote:
> >>
> >>> It seems there are about 80 new, but undocumented addtions at
> >>> the top level Documentation directory.  This fixes up the top
> >>> level 00-INDEX by adding new entries and deleting a couple  
> orphans.
> >>> Some subdirs could probably still use a check/cleanup too though.
> >
> > After this patch, I would prefer to see a requirement that each  
> Documentation/
> > file contain a "topic" line and then generate INDEX files from  
> those automatically...

1) Have you tried running make htmldocs recently? Notice how much  
cleanup needs to be done there? (Yes, it's on my todo list.)

2) How many people know that make htmldocs exists? The advantage of  
00-INDEX is you don't need to be that familiar with the kernel  
documentation to notice it _exists_. If you have to run a step to  
generate it, half the point goes away.

> >
> > comments?
> 
> Rules can sometimes be so inflexible as to prevent additions.
> I think I'd rather see a makefile target that does some sanity
> checks, so that kernel janitors and the like are more apt to
> send trivial patches before it falls behind by 80+ entries like
> it was just recently.   Just my $0.02 opinion.
> 
> P.

Ran my doclinkcheck.py against the "lying around" snapshot I have (less  
than a week old). The attached file is the output. I need to add  
filters. (I should break down and add an X: rule for  
Documentation/devicetree because that's maintained separately by domain  
experts and is a huge source of churn rending the linux-doc list nearly  
unusable. And burying my personal mailbox a bit.)

Also, this doesn't catch stuff like:

cd Documentation; for i in $(find zh_CN -type f); do X="$(echo $i | sed  
's@^zh_CN/@@')"; find $X -newer $i; done

(I.E. are any translated files older than the file that got  
translated...)

Today, Greg KH signed my pgp key at CELF, meaning I can start the  
process of getting my kernel.org account back, which gets me unblocked  
on a lot of this. (I always have the todo list of doom, but all I've  
been able to do since the breakin is forward patches to -trivial, and  
sending big stuff through that seems inappropriate somehow...)

Rob