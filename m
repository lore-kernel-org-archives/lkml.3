Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaLETuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:50:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaLETuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:50:50 -0500
Date: Fri, 5 Dec 2014 13:50:13 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/3] kernel: add support for live patching
Message-ID: <20141205195013.GA16916@treble.redhat.com>
References: <1417708411-23655-1-git-send-email-sjenning@redhat.com>
 <1417708411-23655-3-git-send-email-sjenning@redhat.com>
 <5481F178.9000306@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5481F178.9000306@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 06:55:04PM +0100, Jiri Slaby wrote:
> On 12/04/2014, 04:53 PM, Seth Jennings wrote:
> ...
> > --- /dev/null
> > +++ b/kernel/livepatch/core.c
> > @@ -0,0 +1,902 @@
> ...
> > +static struct kobj_type klp_ktype_patch = {
> > +	.sysfs_ops = &kobj_sysfs_ops,
> > +	.default_attrs = klp_patch_attrs
> > +};
> 
> Hi, I seem to have only a single comment here. If I am looking
> correctly, the last put on this kobject will cause kobject_cleanup to
> generate a warning:
>    "kobject: '%s' (%p): does not have a release() "
>    "function, it is broken and must be fixed.\n",
> 
> There should be some .release. IMO, this is a place where we will
> release the module with the patch. So the .release hook should contain
> something like a commented out module_put() with a pointer to
> klp_register_patch. (Or be empty at worst.)

Ok, thanks.

BTW, Seth will be out for at least the next week.  I'll take over the
patch set until he returns.

-- 
Josh
