Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab3HTOnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3HTOnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:43:14 -0400
Date: Tue, 20 Aug 2013 16:37:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Chen Gang <gang.chen@asianux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: user_namespace: always set the return
	parameter 'new_cred' when call unshare_userns() successfully.
Message-ID: <20130820143722.GA12953@redhat.com>
References: <5212DA37.1090101@asianux.com> <20130820141032.GA4766@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820141032.GA4766@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Serge Hallyn wrote:
>
> Quoting Chen Gang (gang.chen@asianux.com):
> > When unshare_userns() succeed, recommend to always set the return
> > parameter which may be used by caller.
> >
> > The caller has rights to call it with 'new_cred' uninitialized, if
> > succeed, the caller can assume the 'new_cred' has been initialized.
>
> But the only existing caller (sys_unshare) does in fact initialize it to
> NULL.  So while this patch does no harm, is it necessary?

Agreed.

Plus, with this patch unshare_userns() becomes "inconsistent" compared
to other unshare_ helpers.

Oleg.

