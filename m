Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaKQSqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:46:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaKQSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:45:59 -0500
Date: Mon, 17 Nov 2014 10:45:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
Message-ID: <20141117184558.GA13995@kroah.com>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
 <1416187764-3341-3-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416187764-3341-3-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 07:29:23PM -0600, Seth Jennings wrote:
> +#ifdef CONFIG_X86_32
> +int lpc_write_module_reloc(struct module *mod, unsigned long type,
> +			   unsigned long loc, unsigned long value)
> +{
> +	pr_err("Live patching not supported on 32-bit x86\n");
> +	return -ENOSYS;
> +}

Why not just prevent the code from being built on x86_32 instead of
putting this in the file?

thanks,

greg k-h
