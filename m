Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaJAOHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:07:10 -0400
Received: from mout.web.de ([212.227.15.14]:53426 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaJAOHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:07:07 -0400
Message-ID: <542C0A80.3090207@users.sourceforge.net>
Date: Wed, 01 Oct 2014 16:06:56 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Chi Pham <chidaph@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>
Subject: Re: [coccicheck PATCH 3/5] Deletion of unnecessary checks before
 specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <542BFB2C.5070609@users.sourceforge.net>
In-Reply-To: <542BFB2C.5070609@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:FF8RN0HbaWnCycru1C1v+yXwilEcu1lFcECDxAZwJqawuR6560r
 +xpnHXMUT4+V42V5wyetXQ0qHKjsWrK+5XGVyK3xMucOgjJgQVXfvlhDuZ8vNB+gQ2jqbk/
 aZAmqpXj7fwnR8mjsP0sA1PJ+JiOpbSSdu6weMnriim/CXigm0nPRqyB0dM6ZEOh98bBnjL
 Ubz9XVWehUa+M64aUr6BA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> If you are convinced that dropping the null tests is a good idea, then you 
>>> can submit the patch that makes the change to the relevant maintainers and 
>>> mailing lists.

>From f4608fceec40b2b94aa9b4abe3bbb6d98ed5eed9 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Mar 2014 18:58:30 +0100
Subject: [PATCH 3/5] Addition of a SQLite script for a text file import

A script was added so that a text file which was previously generated can be
imported into a SQLite data base table.
http://sqlite.org/sqlite.html

The shown file name can be adjusted by a make file for example.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 .../coccinelle/deletions/handle_function_list_template.sqlite    | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644
scripts/coccinelle/deletions/handle_function_list_template.sqlite

diff --git a/scripts/coccinelle/deletions/handle_function_list_template.sqlite
b/scripts/coccinelle/deletions/handle_function_list_template.sqlite
new file mode 100644
index 0000000..bec366c
--- /dev/null
+++ b/scripts/coccinelle/deletions/handle_function_list_template.sqlite
@@ -0,0 +1,9 @@
+create table positions(function text,
+                       data_type text,
+                       parameter text,
+                       source_file text,
+                       line integer,
+                       column integer);
+.separator "|"
+.import list_input_pointer_validation1.txt positions
+.header OFF
-- 
1.9.0



