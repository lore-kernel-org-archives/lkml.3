Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936473Ab3DIQ1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:27:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43930 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936133Ab3DIQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:26:58 -0400
Message-ID: <1365524815.6865.54.camel@joe-AO722>
Subject: Re: [PATCH v3 1/1] Introduce Intel RAPL cooling device driver
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 09 Apr 2013 09:26:55 -0700
In-Reply-To: <20130409091517.3b73a583@chromoly>
References: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
	 <20130409152638.GA3033@kroah.com> <20130409091517.3b73a583@chromoly>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 09:15 -0700, Jacob Pan wrote:
> On Tue, 9 Apr 2013 08:26:38 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > +	if (NULL == rp->name || rp->flag & RAPL_PRIMITIVE_DUMMY)
> > 
> > In Linux we do (rp->name == NULL), or even better yet (!rp->name),
> > please fix that up here and elsewhere in the driver.
> > 
> I can fix that. I did that because checkpatch does not complain about
> it. also it avoids common mistake as:
> rp->name = NULL
> 
> > > +
> > > +#define PRIMITIVE_INFO_INIT(p, m, s, i, u, f) {#p, m, s, i, u, p,
> > > f}
> > 
> > C has named initializers, use them please.
> > 
> this macro can save lots of repeated text.

Use the macro.  Use named initializers in the macro.

#define PRIMITIVE_INFO_INIT(p, m, s, i, u, f)	\
{						\
	.name = #p,				\
	.mask = m,				\
	.shift = s,				\
	.id = i,				\
	.unit = u,				\
/*						\
(hmm looks like a bug ?)			\
	enum rapl_primitives pm_id;		\
*/						\
	.flag = f,				\
}


