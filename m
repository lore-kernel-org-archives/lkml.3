Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaAISXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:23:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbaAISXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:23:41 -0500
Date: Thu, 9 Jan 2014 13:23:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Baoquan <bhe@redhat.com>,
        linux-acpi@vger.kernel.org, zhangyanfei@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, dyoung@redhat.com
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
Message-ID: <20140109182310.GG25897@redhat.com>
References: <52CD6E33.400@redhat.com>
 <20140108155829.GC13649@redhat.com>
 <8500545.JVNPnKcyD1@vostro.rjw.lan>
 <1389226308.1792.39.camel@misato.fc.hp.com>
 <20140109145035.GB25897@redhat.com>
 <1389283439.1792.66.camel@misato.fc.hp.com>
 <20140109162427.GF25897@redhat.com>
 <1389288265.1792.108.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389288265.1792.108.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 10:24:25AM -0700, Toshi Kani wrote:

[..]
> > I think creating a new command line option is simpler as compared to
> > creating a new flag in bootparam which in turn disables memory hotplug.
> > More users can use that option. For example, if for some reason hotplug
> > code is crashing, one can just disable it on command line as work around
> > and move on.
> 
> I do not have a strong opinion about having such option.  However, I
> think it is more user friendly to keep the exactmap option works alone
> on any platforms.

I think we should create internally a variable which will disable memory
hotplug. And set that variable based on memmap=exactmap, mem=X and also
provide a way to disable memory hotplug directly using command line
option.

Current kexec-tools can use memmap=exactmap and be happy. I am writing
a new kexec syscall and will not be using memmap=exactmap and would need
to use that command line option to disable memory hotplug behavior.

Thanks
Vivek
