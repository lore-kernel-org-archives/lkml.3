Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaIKWhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:37:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaIKWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:37:47 -0400
Date: Thu, 11 Sep 2014 15:37:39 -0700
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
Subject: Re: [PATCH v2] eeepc-laptop: simplify parse_arg()
Message-ID: <20140911223739.GB18425@vmdeb7>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
 <1409814488.5546.63.camel@x220>
 <20140906021757.GA9197@vmdeb7>
 <7288841.ayNsq2yeGO@vostro.rjw.lan>
 <1410252608.22255.5.camel@x220>
 <20140910033304.GB39541@vmdeb7>
 <CAH6sp9NtLDG4AvpTF7KzxwxVhrj8ZzNLugwoU5=YrLp65AptQQ@mail.gmail.com>
 <20140910164916.GA48285@vmdeb7>
 <1410379520.11097.18.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410379520.11097.18.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:05:20PM +0200, Paul Bolle wrote:
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
> While we're at it, let store_sys_acpi() return whatever error set_acpi()
> returns instead of remapping it to EIO.
> 
> A nice side effect is that this GCC warning is silenced too:
>     drivers/platform/x86/eeepc-laptop.c: In function ‘store_sys_acpi’:
>     drivers/platform/x86/eeepc-laptop.c:279:10: warning: ‘value’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>       int rv, value;
> 
> Which is, of course, the reason to have a look at parse_arg().
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Queued, thanks Paul.

-- 
Darren Hart
Intel Open Source Technology Center
