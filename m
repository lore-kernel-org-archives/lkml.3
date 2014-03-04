Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbaCDObd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:31:33 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:55790 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbaCDObc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:31:32 -0500
Date: Tue, 4 Mar 2014 20:01:11 +0530
From: yogesh <mr.yogesh@gmail.com>
To: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1] Add documentation for proper usage and order of
 preference of calls to print diagnostic messages.
Message-ID: <20140304143111.GA4074@yogesh-Dell-System-XPS-L502X>
References: <20140304114814.GA28031@yogesh-Dell-System-XPS-L502X>
 <CAAsK9AF-jbJZHOT+4gY0QmZFMhj84_DuSD9jDgddDH03vodcYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAsK9AF-jbJZHOT+4gY0QmZFMhj84_DuSD9jDgddDH03vodcYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation that clarifies the use of various
diagnostic printing messages. It shows the preference of subsystem_dbg
calls to dev_dbg (whenever possible), as they first preferred format of
logging debug messages.
Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
---
 Documentation/CodingStyle | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 7fe0546..083f738 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -662,6 +662,23 @@ and driver, and are tagged with the right level:  dev_err(), dev_warn(),
 dev_info(), and so forth.  For messages that aren't associated with a
 particular device, <linux/printk.h> defines pr_debug() and pr_info().
 
+If the subsystem has its own diagnostic macros then they should be used
+instead of dev_dbg calls.
+e.g. If you are using network subsystem, use netdev_dbg;
+if you are using V4L, use v4l_dbg etc.
+This standardises the output format in every subsystem.
+
+Depending on your changes, the following order of precedence
+applies to printing messages:
+1. [subsystem]_dbg() is preferred when the subsystem has its own
+diagnostic macros.
+2. dev_dbg() is preferred when you have a generic struct device object.
+3. pr_debug() should be used when 1 and 2 above are not applicable.
+4. printk() should be avoided.
+
+Note: The above order applies to diagnostic calls of all log levels viz:
+*_emerg, *_alert, *_crit, *_err, *_warn, *_notice, *_info and *_dbg.
+
 Coming up with good debugging messages can be quite a challenge; and once
 you have them, they can be a huge help for remote troubleshooting.  Such
 messages should be compiled out when the DEBUG symbol is not defined (that
--

Regards
Yogesh
On Tue, Mar 04, 2014 at 02:39:42PM +0100, Levente Kurusa wrote:
> Hi,
> 
> 2014-03-04 12:48 GMT+01:00 yogesh <mr.yogesh@gmail.com>:
> > This patch adds documentation that clarifies the use of various diagnostic printing messages. It shows the preference of subsystem_dbg calls to dev_dbg (whenever possible), as the first preferred format of logging debug messages.
> 
> Please wrap your changelog at 80 characters a line.
> 
> > Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
> > ---
> >  Documentation/CodingStyle | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> > index 7fe0546..9e0de25 100644
> > --- a/Documentation/CodingStyle
> > +++ b/Documentation/CodingStyle
> > @@ -662,6 +662,20 @@ and driver, and are tagged with the right level:  dev_err(), dev_warn(),
> >  dev_info(), and so forth.  For messages that aren't associated with a
> >  particular device, <linux/printk.h> defines pr_debug() and pr_info().
> >
> > +If the subsystem has its own diagnostic macros then they should be used
> > +instead of dev_dbg calls.
> > +e.g. If you are using network subsystem, use netdev_dbg;
> > +if you are using V4L, use v4l_dbg etc.
> > +This standardises the output format in every subsystem.
> > +
> > +Depending on your changes, the following order of precedence
> > +applies to printing messages:
> > +1. [subsystem]_dbg() is preferred when you the
> 
> The 'you' is unnecessary and incorrect.
> 
> > +subsystem has its own diagnostic macros.
> > +2. dev_dbg() is preferred when you have a generic struct device object.
> > +3. pr_debug() is used when 1 and 2 above are not applicable.
> 
> I think it's better to say "should be used".
> 
> > +4. printk() should be avoided.
> > +
> >  Coming up with good debugging messages can be quite a challenge; and once
> >  you have them, they can be a huge help for remote troubleshooting.  Such
> >  messages should be compiled out when the DEBUG symbol is not defined (that
> 
> I think we should also mention *_warn, *_err etc not just *_dbg.
> 
> --
> Regards,
> Levente Kurusa
