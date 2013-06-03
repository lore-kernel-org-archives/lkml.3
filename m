Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3FCA0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 20:26:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48274 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab3FCA0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 20:26:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,790,1363104000"; 
   d="scan'208";a="7439786"
Subject: Re: [PATCH 3/4] sys/reboot: boolize C_A_D
From: li guang <lig.fnst@cn.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20130531160259.553761ddeb6095d22e8cea0d@linux-foundation.org>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1369900686-5936-3-git-send-email-lig.fnst@cn.fujitsu.com>
	 <20130531160259.553761ddeb6095d22e8cea0d@linux-foundation.org>
Date: Mon, 03 Jun 2013 08:25:25 +0800
Message-ID: <1370219125.17798.0.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 08:24:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 08:24:35,
	Serialize complete at 2013/06/03 08:24:35
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-05-31五的 16:02 -0700，Andrew Morton写道：
> On Thu, 30 May 2013 15:58:05 +0800 liguang <lig.fnst@cn.fujitsu.com> wrote:
> 
> > --- a/include/linux/reboot.h
> > +++ b/include/linux/reboot.h
> > @@ -35,7 +35,7 @@ extern void kernel_restart(char *cmd);
> >  extern void kernel_halt(void);
> >  extern void kernel_power_off(void);
> >  
> > -extern int C_A_D; /* for sysctl */
> > +extern bool C_A_D; /* for sysctl */
> >  void ctrl_alt_del(void);
> 
> This means that the pointer in kernel/sysctl.c:kern_table.data now
> points at a bool but is declared to have size sizeof(int).
> 
> That happens to work with current gcc verions, but there's no rule
> which states that sizeof(bool) must equal sizeof(int).
> 
> And I'm not sure that changing kern_table to use sizeof(bool) is really
> worth all the bother.

OK, got it,

Thanks!

