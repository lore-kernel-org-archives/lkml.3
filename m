Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3EUQdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab3EUQdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:33:08 -0400
Date: Tue, 21 May 2013 18:29:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        akpm@linux-foundation.org, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        bharrosh@panasas.com, devel@openvz.org
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
Message-ID: <20130521162925.GA19785@redhat.com>
References: <20130520070017.7957.9224.stgit@localhost.localdomain> <20130520135716.GA10084@redhat.com> <519A3693.8020006@parallels.com> <20130520151001.GA13173@redhat.com> <20130520212412.GI14677@fieldses.org> <20130521152836.GA13461@redhat.com> <20130521153531.GO14677@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521153531.GO14677@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, J. Bruce Fields wrote:
>
> On Tue, May 21, 2013 at 05:28:36PM +0200, Oleg Nesterov wrote:
> >
> > OK, so do not do this. Export the new helper.
>
> You mean, export umh_set_fs_root() in the above?
>
> That might be OK.

Yes, or even call_usermodehelper_root().

I didn't argue with the new helper that, yes, has the additional
argument. Although personally I think it would be better to not
add it into kmod.c (until it has more users), but I am not sure
there is a better place somewhere in nfs code. Whatever is more
convenient for you.

To me this looks like call_usermodehelper_keys().

Oleg.

