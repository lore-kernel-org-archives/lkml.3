Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaCEWwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:52:44 -0500
Received: from mout.web.de ([212.227.15.4]:65096 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaCEWwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:52:43 -0500
Message-ID: <5317AAB8.20703@users.sourceforge.net>
Date: Wed, 05 Mar 2014 23:52:40 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org
Subject: Re: [coccicheck Linux 3.14-rc5 PATCH 3 of 5] Deletion of unnecessary
 checks before specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:PXzjkBbA/M5EHLroNRoZeUl4IIrO+nCb7Q7g7oDlx2BS7ontWGG
 RDYkhs7Y14vhyqtNulnhxZlquJxZQiXkJQth9aSH0iFwd/0ImA/WfMa2iJ7JgRWLe85HpNQ
 P5FakpfzYvn966FpUOxxRaclNiggFFCqkNcVd3cn6vBhHjLiAD10qmIDxS66u+nLs+oASvf
 5ehjKceG+/xWj1PLscUIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

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


