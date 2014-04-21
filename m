Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaDUQu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:50:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:9664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaDUQuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:50:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,896,1389772800"; 
   d="scan'208";a="496840454"
Date: Mon, 21 Apr 2014 09:50:50 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kbuild, lto: Avoid reported warning with strtoul
Message-ID: <20140421165050.GB8874@tassilo.jf.intel.com>
References: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
 <CAKohpond9DbNqWHLi9ZdL0BJRwZjeDZcar7KYuC2kAvWZp96-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpond9DbNqWHLi9ZdL0BJRwZjeDZcar7KYuC2kAvWZp96-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 10:25:18AM +0530, Viresh Kumar wrote:
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -1707,7 +1707,7 @@ static char *remove_dot(char *s)
> >         int n = strcspn(s, ".");
> >
> >         if (n > 0 && s[n] != 0) {
> > -               strtoul(s + n + 1, &end, 10);
> > +               (void)strtoul(s + n + 1, &end, 10);
> 
> I tried this earlier before reporting and it still had the same problem :(
> I tried it again just to cross check and still getting this:
> 
> scripts/mod/modpost.c: In function ‘remove_dot’:
> scripts/mod/modpost.c:1710:3: warning: ignoring return value of
> ‘strtoul’, declared with attribute warn_unused_result
> [-Wunused-result]

Hmm that's odd. I guess could assign it to a dummy variable or use
viro's variant.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
