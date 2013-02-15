Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3BOXou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:44:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3BOXos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:44:48 -0500
Date: Fri, 15 Feb 2013 15:44:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: <viro@zeniv.linux.org.uk>, <eric.dumazet@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 resend] procfs: Improve Scaling in proc
Message-Id: <20130215154447.afd1e259.akpm@linux-foundation.org>
In-Reply-To: <511EC73A.4050008@sgi.com>
References: <1360961274-24652-1-git-send-email-nzimmer@sgi.com>
	<20130215141239.99a3bccc.akpm@linux-foundation.org>
	<511EC73A.4050008@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 17:39:38 -0600
Nathan Zimmer <nzimmer@sgi.com> wrote:

> > So are all these games with local variable `llseek' still needed?
> > afaict the increment of pde_users will stabilize ->fops?
> We still are setting de->proc_fops to NULL to prevent new callers.
> Also we still have to save fops-> since we cannot use fops outside the 
> rcu_read_un/lock.
> Unless I misunderstood your question.

ah, so we are.
