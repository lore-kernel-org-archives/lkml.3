Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3KLQ13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:27:29 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44746 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab3KLQ11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:27:27 -0500
Message-ID: <1384272557.5754.30.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: scripts: checkpatch.pl & Lindent (minor complaint)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:09:17 -0500
In-Reply-To: <1384271045.4771.47.camel@joe-AO722>
References: <1384267377.5754.25.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1384271045.4771.47.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111216-0320-0000-0000-000001B2D93B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 07:44 -0800, Joe Perches wrote:
> On Tue, 2013-11-12 at 09:42 -0500, Mimi Zohar wrote: 
> > scripts/Lindent and scripts/checkpatch disagree whether the fields in a
> > statically initialized array should be blank separated.  
> > 
> > static struct ima_rule_entry default_rules[] = {
> >         {.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
> > 
> > Lindent adds a blank before '.fsmagic', which checkpatch then complains
> > about (eg. commit 75834fc3).
> 
> Perhaps I don't understand what you mean.

> Lindent _doesn't_add a blank and checkpatch
> seems to do the right thing here.

Sorry, my mistake.  It's the reverse.  Checkpatch complains about the
missing blank, which Lindent then removes.

#40: FILE: security/integrity/ima/ima_policy.c:52:
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags =
IMA_FSMAGIC},

ERROR: space required after that ',' (ctx:VxV)
#40: FILE: security/integrity/ima/ima_policy.c:52:
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags =
IMA_FSMAGIC},
 	                       ^
ERROR: space required after that ',' (ctx:VxV)

Mimi

