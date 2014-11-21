Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbaKUPgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:36:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675AbaKUPgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:36:17 -0500
Date: Fri, 21 Nov 2014 09:35:35 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141121153535.GC26264@treble.redhat.com>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
 <20141121152103.GB26264@treble.redhat.com>
 <alpine.LNX.2.00.1411211626110.23174@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411211626110.23174@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 04:27:57PM +0100, Jiri Kosina wrote:
> On Fri, 21 Nov 2014, Josh Poimboeuf wrote:
> 
> > I think we can use "depends on HAVE_FENTRY" to accomplish this, since 
> > CC_USING_FENTRY gets set by the top level kernel Makefile if 
> > CONFIG_HAVE_FENTRY is set.
> 
> The problem is that HAVE_FENTRY is set automatically on x86_64, no matter 
> whether your actual compiler supports it or not.
> 
> CC_USING_FENTRY is defined if and only if the actual currently used 
> compiler supports it, but that can't be expressed in Kconfig.

Ah, light bulb moment.  Now I understand what "$(call cc-option, ...)"
does.

Thanks :-)

-- 
Josh
