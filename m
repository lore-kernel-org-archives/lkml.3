Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab3DDLtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:49:52 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6608 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758405Ab3DDLtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:49:51 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Thu, 4 Apr 2013 13:49:48 +0200
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        =?iso-8859-1?Q?Davidsson=2C_Bj=F6rn?= 
	<Bjorn.Davidsson@sonymobile.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/4] kprobes: split blacklist into common and arch
Message-ID: <20130404114948.GD2481@caracas.corpusers.net>
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
 <1364977734-32267-3-git-send-email-oskar.andero@sonymobile.com>
 <515D1AF5.3010900@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <515D1AF5.3010900@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:17 Thu 04 Apr     , Masami Hiramatsu wrote:
> (2013/04/03 17:28), oskar.andero@sonymobile.com wrote:
> > Some blackpoints are only valid for specific architectures. To let each
> > architecture specify its own blackpoints the list has been split in two
> > lists: common and arch. The common list is kept in kernel/kprobes.c and
> > the arch list is kept in the arch/ directory.
> 
> Hmm, I think you'd better merge this with patch 3/4.

IMHO I think it's more logical to keep them separated instead of
squashing a generic patch with an architecture specific patch.
Also, there is the matter of authorship and credits.

Of course, it's your call, so let me know if this is ok with you.

> [...]
> > +static const size_t common_kprobes_blacksyms_size =
> > +			ARRAY_SIZE(common_kprobes_blacksyms);
> > +
> > +extern const char * const arch_kprobes_blacksyms[];
> > +extern const size_t arch_kprobes_blacksyms_size;
> > +
> > +static struct kprobe_blackpoint **kprobe_blacklist;
> > +static size_t kprobe_blacklist_size;
> 
> Since the blacklist is allocated once and never be updated,
> we just need an array of struct kprobe_blackpoint, no need
> to allocate each entry.

Right. I'll change that.

Thanks!

-Oskar
