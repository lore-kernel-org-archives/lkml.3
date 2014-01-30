Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaA3VvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:51:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaA3VvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:51:13 -0500
Date: Thu, 30 Jan 2014 13:51:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        "Joe Perches" <joe@perches.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        "Michel Lespinasse" <walken@google.com>,
        "Shaohua Li" <shli@kernel.org>,
        "Jerome Marchand" <jmarchan@redhat.com>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v5 1/2] mm: add kstrimdup function
Message-Id: <20140130135111.cffc7d8852dd38545bddeb75@linux-foundation.org>
In-Reply-To: <20140130214545.18296.69349@capellas-linux>
References: <1391116318-17253-1-git-send-email-sebastian.capella@linaro.org>
	<1391116318-17253-2-git-send-email-sebastian.capella@linaro.org>
	<20140130132251.4f662aeddc09d8410dee4490@linux-foundation.org>
	<20140130214545.18296.69349@capellas-linux>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 13:45:45 -0800 Sebastian Capella <sebastian.capella@linaro.org> wrote:

> Quoting Andrew Morton (2014-01-30 13:22:51)
> > On Thu, 30 Jan 2014 13:11:57 -0800 Sebastian Capella <sebastian.capella@linaro.org> wrote:
> > > +char *kstrimdup(const char *s, gfp_t gfp)
> > > +{
> > > +     char *buf;
> > > +     char *begin = skip_spaces(s);
> > > +     size_t len = strlen(begin);
> > > +
> > > +     while (len > 1 && isspace(begin[len - 1]))
> > > +             len--;
> > 
> > That's off-by-one isn't it?  kstrimdup("   ") should return "", not " ".
> > 
> > > +     buf = kmalloc_track_caller(len + 1, gfp);
> > > +     if (!buf)
> > > +             return NULL;
> > > +
> > > +     memcpy(buf, begin, len);
> > > +     buf[len] = '\0';
> > > +
> > > +     return buf;
> > > +}
> 
> Hi Andrew,
> 
> I think this is a little tricky.
> 
> For an empty string, the function relies on skip_spaces to point begin
> at the \0'.
> 
> Alternately, if we don't have an empty string, we know we have at least 1
> non-space, non-null character at begin[0], and there's no need to check it,
> so the loop stops at [1].  If there's a space at 1, we just put the '\0'
> there.
> 
> We could check at [0], but I think its already been checked by skip_spaces.

heh, OK, tricky.
