Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab3GaR4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:56:55 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:41950 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3GaR4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:56:54 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options
Date: Wed, 31 Jul 2013 13:56:50 -0400
Message-ID: <2522719.Q8VOfUrvSY@sifl>
User-Agent: KMail/4.10.5 (Linux/3.10.2-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51F93130.6040506@schaufler-ca.com>
References: <51F16CFB.6040603@schaufler-ca.com> <6712209.BXb1SVfVxH@sifl> <51F93130.6040506@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 31, 2013 08:45:52 AM Casey Schaufler wrote:
> On 7/30/2013 2:47 PM, Paul Moore wrote:
> > On Thursday, July 25, 2013 11:32:23 AM Casey Schaufler wrote:
> >> Subject: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options
> >> 
> >> Refine the handling of SO_PEERSEC to enable legacy
> >> user space runtimes, Fedora in particular, when running
> >> with multiple LSMs that are capable of providing information
> >> using getsockopt(). This introduces an additional configuration
> >> option, and requires that the default be the legacy behavior.
> >> 
> >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > ...
> > 
> >> --- a/security/Kconfig
> >> +++ b/security/Kconfig
> >> @@ -157,17 +157,49 @@ config SECMARK_LSM
> >> 
> >>  	help
> >>  	
> >>  	  The name of the LSM to use with the networking secmark
> >> 
> >> -config SECURITY_PLAIN_CONTEXT
> >> -	bool "Backward compatable contexts without lsm='value' formatting"
> >> -	depends on SECURITY_SELINUX || SECURITY_SMACK
> >> -	default y
> >> +choice
> >> +	depends on SECURITY && (SECURITY_SELINUX || SECURITY_SMACK)
> >> +	prompt "Peersec LSM"
> >> +	default PEERSEC_SECURITY_FIRST
> >> +
> >> 
> >>  	help
> >> 
> >> -	  Without this value set security context strings will
> >> -	  include the name of the lsm with which they are associated
> >> -	  even if there is only one LSM that uses security contexts.
> >> -	  This matches the way contexts were handled before it was
> >> -	  possible to have multiple concurrent security modules.
> >> -	  If you are unsure how to answer this question, answer Y.
> >> +	  Select the security module that will send attribute
> >> +	  information in IP header options.
> >> +	  Most SELinux configurations do not take advantage
> >> +	  of Netlabel, while all Smack configurations do. Unless
> >> +	  there is a need to do otherwise chose Smack in preference
> >> +	  to SELinux.
> > 
> > I'm not hugely in love with the help text; the first sentence seems to be
> > all that is needed, the second seems unnecessary and not exactly fair to
> > the LSMs.
>
> I can take out the "friendly advice". What it really should say
> is more on the lines of:
> 
> 	If you have gotten to the point where you have to make
> 	this decision you should probably call it a work day, go
> 	home, have a nice drink and spend some time with a loved
> 	one. In the morning take a good hard look at your network
> 	configuration. You may end up with a different security
> 	policies being enforced with IPv4 and IPv6 communications.

Perfect ;)

-- 
paul moore
www.paul-moore.com

