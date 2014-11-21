Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbaKUOoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:44:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbaKUOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:44:29 -0500
Date: Fri, 21 Nov 2014 15:44:35 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
In-Reply-To: <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1411211542180.27891@pobox.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Jiri Kosina wrote:

[...]

> [ ... snip ... ]
> > +static int klp_init_patch(struct klp_patch *patch)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&klp_mutex);
> > +
> > +	/* init */
> > +	patch->state = LPC_DISABLED;
> > +
> > +	/* sysfs */
> > +	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
> > +				   klp_root_kobj, patch->mod->name);
> > +	if (ret)
> > +		return ret;
> 
> klp_mutex is leaked locked here.
> 
> > +
> > +	/* create objects */
> > +	ret = klp_init_objects(patch);
> > +	if (ret) {
> > +		kobject_put(&patch->kobj);
> > +		return ret;
> 
> And here as well.
> 
> All in all, this is looking very good to me. I think we are really close 
> to having a code that all the parties would agree with. Thanks everybody,

The leaking is my fault. I missed that somehow during rebasing.

Seth, could you please fix it in v4? 

Thanks
--
Miroslav Benes
SUSE Labs
