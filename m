Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbaFSS7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:59:09 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:53827 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbaFSS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:59:08 -0400
From: Paul Moore <paul@paul-moore.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        selinux@tycho.nsa.gov, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] selinux: simple cleanup for cond_read_node()
Date: Thu, 19 Jun 2014 14:59:04 -0400
Message-ID: <18713609.X6uzY7R5jD@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <CAM9d7cj07=ERVUnEhpCu6g72HsXCFSFmha8U6BZL6BbYBxckEg@mail.gmail.com>
References: <1402762742-2808-1-git-send-email-namhyung@kernel.org> <1719649.5PAcuqR8Pm@sifl> <CAM9d7cj07=ERVUnEhpCu6g72HsXCFSFmha8U6BZL6BbYBxckEg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 19, 2014 08:58:31 AM Namhyung Kim wrote:
> Hi Paul,
> 
> On Thu, Jun 19, 2014 at 4:36 AM, Paul Moore <paul@paul-moore.com> wrote:
> > > @@ -402,19 +402,14 @@ static int cond_read_node(struct policydb *p,
> > > struct
> >> 
> >> cond_node *node, void *fp) int rc;
> >> 
> >>       struct cond_expr *expr = NULL, *last = NULL;
> >> 
> >> -     rc = next_entry(buf, fp, sizeof(u32));
> >> +     rc = next_entry(buf, fp, sizeof(buf));
> > 
> > This is a bit nit-picky, but how about using "sizeof(u32) * 2"?  It is
> > more
> > consistent with the rest of the function and helps underscore that we are
> > reading two 32-bit values.
> > 
> > Assuming you're okay with the change I can fix it up when I apply the
> > patch.
>
> I'm okay with it. :)

Great, both patches are applied.

-- 
paul moore
www.paul-moore.com

