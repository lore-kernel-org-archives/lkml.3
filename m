Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaGCTF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:05:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbaGCTF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:05:27 -0400
Date: Thu, 3 Jul 2014 15:05:06 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm readahead: Fix sys_readahead breakage by reverting
 2MB limit (bug 79111)
Message-ID: <20140703190506.GA24683@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	David Cohen <david.a.cohen@linux.intel.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
	David Rientjes <rientjes@google.com>,
	Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
	linux-mm <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com>
 <53B59CB5.9060004@linux.vnet.ibm.com>
 <CA+55aFyRgYW6Y8paYKGfqE205enhiPsZ1C8wrKpFavVXq7ZAtA@mail.gmail.com>
 <CA+55aFwwSCrH5QDvrzzyHhRU5R849Mo8A3NdRMwm9OTeWH9diQ@mail.gmail.com>
 <53B5A343.4090402@linux.vnet.ibm.com>
 <CA+55aFyqK90YJkjtHR2QGFt4Mvn=mj8a4FkB_8nbTTj3=jp3NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyqK90YJkjtHR2QGFt4Mvn=mj8a4FkB_8nbTTj3=jp3NA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 11:53:57AM -0700, Linus Torvalds wrote:
 > On Thu, Jul 3, 2014 at 11:38 AM, Raghavendra K T
 > <raghavendra.kt@linux.vnet.ibm.com> wrote:
 > >
 > > Okay, how about something like 256MB? I would be happy to send a patch
 > > for that change.
 > 
 > I'd like to see some performance numbers. I know at least Fedora uses
 > "readahead()" in the startup scripts, do we have any performance
 > numbers for that?

this got rolled up into systemd a while ago, so it's not just Fedora.

re: numbers, systemd-analyze and systemd-bootchart look like the way
to figure that out..
https://wiki.archlinux.org/index.php/Improve_boot_performance

	Dave

