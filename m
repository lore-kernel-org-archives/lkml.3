Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbbAZNKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:10:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64865 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751244AbbAZNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:10:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] int to bool conversion
Date: Mon, 26 Jan 2015 14:32:46 +0100
Message-ID: <2189735.DtT3OIbRBT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54C5FB3F.6000803@gmail.com>
References: <20150122084941.GA14651@sloth> <1659960.ohcxabvmYi@vostro.rjw.lan> <54C5FB3F.6000803@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 26, 2015 09:30:55 AM Quentin Lambert wrote:
> Sorry for the delay in answering ....
> 
> On 22/01/2015 17:18, Rafael J. Wysocki wrote:
> > On Thursday, January 22, 2015 09:49:41 AM Quentin Lambert wrote:
> >> These patches convert local variables from int to bool when relevant.
> > And what exactly is the need for that?  Does that fix any functional problems?
> >
> >
> It doesn't fix any functional problem. The point of this patch
> is to increase the code readability by lifting some of the ambiguities
> that appear when using an integer variable as boolean.
> 
> My understanding is that by explicitly using a boolean declaration
> when it is relevant it clearly informs the reader that the variable
> is going to represent a binary state. Moreover, using the keywords
> true and false help indicate that the variable will not be involved
> in any computation other than boolean arithmetic.

Well, in the new code, yes.  The existing code is a different matter though
and it doesn't actually hurt if you leave the ints where they are, so there's
no reason to make those changes.

If you change old code and the change is not trivial (eg. fixes of white space
or comments, or kernel messages etc.) and someone enounters a bug that may be
related to it, they will have to go through your changes to see if that's not
the source of the bug.  That's not really productive.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
