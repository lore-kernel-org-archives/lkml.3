Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3HUMDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:03:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab3HUMDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:03:36 -0400
Date: Wed, 21 Aug 2013 13:57:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: user_namespace: always set the return
	parameter 'new_cred' when call unshare_userns() successfully.
Message-ID: <20130821115739.GA2965@redhat.com>
References: <5212DA37.1090101@asianux.com> <20130820141032.GA4766@sergelap> <20130820143722.GA12953@redhat.com> <52143EE0.3040604@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52143EE0.3040604@asianux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Chen Gang wrote:
>
> On 08/20/2013 10:37 PM, Oleg Nesterov wrote:
> > On 08/20, Serge Hallyn wrote:
> >>
> >>
> >> But the only existing caller (sys_unshare) does in fact initialize it to
> >> NULL.  So while this patch does no harm, is it necessary?
> >
> > Agreed.
> >
> > Plus, with this patch unshare_userns() becomes "inconsistent" compared
> > to other unshare_ helpers.
> >
>
> Hmm... for static functions, they don't need, but for extern functions,
> recommend to do so.
>
>
> For "unshare_ helpers", I find 3 extern functions:
>
>   unshare_files() which already set value.
>   unshare_userns() and unshare_nsproxy_namespaces() which not set.
>
> In my opinion, recommend to always set the return parameter when
> succeed, for the 2 left extern functions.

I do not think that static/extern should make any difference. To me,
the cleanup should make unshare_userns() return "cred *" (or NULL or
ERR_PTR()) But this is subjective and in this case we should change
other unshare_ helpers too. Doesn't worth the trouble.

Oleg.

