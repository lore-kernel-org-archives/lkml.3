Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbaIQUfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:35:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbaIQUfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:35:20 -0400
Date: Wed, 17 Sep 2014 13:35:10 -0700
From: Darren Hart <dvhart@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Frans Klaver <fransklaver@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] eeepc-laptop: simplify parse_arg()
Message-ID: <20140917203510.GA12682@vmdeb7>
References: <20140906021757.GA9197@vmdeb7>
 <7288841.ayNsq2yeGO@vostro.rjw.lan>
 <1410252608.22255.5.camel@x220>
 <20140910033304.GB39541@vmdeb7>
 <CAH6sp9NtLDG4AvpTF7KzxwxVhrj8ZzNLugwoU5=YrLp65AptQQ@mail.gmail.com>
 <20140910164916.GA48285@vmdeb7>
 <1410379520.11097.18.camel@x220>
 <20140911223739.GB18425@vmdeb7>
 <20140916234543.GA22408@vmdeb7>
 <1410980571.10248.6.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410980571.10248.6.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:02:51PM +0200, Paul Bolle wrote:
> parse_arg() has three possible return values:
>     -EINVAL if sscanf(), in short, fails;
>     zero if "count" is zero; and
>     "count" in all other cases
> 
> But "count" will never be zero. See, parse_arg() is called by the
> various store functions. And the callchain of these functions starts
> with sysfs_kf_write(). And that function checks for a zero "count". So
> we can stop checking for a zero "count", drop the "count" argument
> entirely, and transform parse_arg() into a function that returns zero on
> success or a negative error. That, in turn, allows to make those store
> functions just return "count" on success. The net effect is that the
> code becomes a bit easier to understand.
> 
> A nice side effect is that this GCC warning is silenced too:
>     drivers/platform/x86/eeepc-laptop.c: In function ‘store_sys_acpi’:
>     drivers/platform/x86/eeepc-laptop.c:279:10: warning: ‘value’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>       int rv, value;
> 
> Which is, of course, the reason to have a look at parse_arg().
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Still build tested only, but now on top of v3.17-rc5. Has Frans tested
> writing zero length values to these sysfs files?

Frans, can you confirm testing when you get a chance please?

-- 
Darren Hart
Intel Open Source Technology Center
