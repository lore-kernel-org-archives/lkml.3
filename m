Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3KDVvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 16:51:49 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:51151
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753825Ab3KDVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 16:51:36 -0500
Date: Mon, 4 Nov 2013 21:51:35 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Victor Marmol <vmarmol@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        Rohit Jnagal <jnagal@google.com>
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20131104215135.GA26190@mail.hallyn.com>
References: <20130723181606.GA6342@sergelap>
 <20130723183018.GF21100@mtj.dyndns.org>
 <20130723183841.GA9021@tp>
 <CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
 <20130723190426.GA9577@tp>
 <20130723191245.GI21100@mtj.dyndns.org>
 <20130723192801.GA9923@tp>
 <CAOS58YPEKtEiZWsn-8u6OPr-UsyQp=XR+ecGmXyOdT0JnYAmsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YPEKtEiZWsn-8u6OPr-UsyQp=XR+ecGmXyOdT0JnYAmsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Hello, Serge.
> 
> On Tue, Jul 23, 2013 at 3:28 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > On Tue, Jul 23, 2013 at 02:04:26PM -0500, Serge Hallyn wrote:
> > > If task A is uid 1000 on the host, and creates task B as uid X in a new
> > > user namespace, then task A, still being uid 1000 on the host, is
> > > privileged with respect to B and his namespace - i.e.
> > > ns_capable(B->userns, CAP_SYS_ADMIN) is true.
> 
> >> Well, that also is the exact type of priv delegation we're moving away
> >> from, so....
> >
> > I think that's unreasonable, but I guess I'll have to go reread the
> > old thread.
> 
> Yeah, please do. I think the case is pretty strong for disallowing
> delegation of cgroup directories to !root (or whatever CAP it should
> be) users. It's inherently unsafe for some controllers and ends up
> leaking kernel implementation details into regular binaries thus
> cementing those leaked details as APIs, which is a giant no-no.

Hi Tejun,

So to come back to this...  At plumbers, I believe you were not present
at the 'let me contain that for you' session.  There the "delegation is
not safe" topic came up.  When pressed, the only example that came up
was (IIRC) having to do with an rt scheduling issue which, all agreed,
was a bug in the implementation which should be fixed, rather than a valid
reason to say that delegation of cgroups should be fundamentally not supported.

Do you have a list of such issues which you see with delegation?  That is,
cases where, if ownership of a subtree is granted to a non-root user,
that user can affect tasks owned by other users who are in other
cgroups?

-serge
