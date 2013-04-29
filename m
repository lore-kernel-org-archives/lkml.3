Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3D2WbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:31:03 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48093 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab3D2WbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:31:00 -0400
Date: Tue, 30 Apr 2013 00:30:54 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Benjamin Poirier <bpoirier@suse.de>
Subject: Re: [PATCH 1/1] kconfig: fix lists definition for C++
Message-ID: <20130429223054.GB31039@free.fr>
References: <cover.1367258255.git.yann.morin.1998@free.fr>
 <21ca352b71ca252e1933b1538fe89da8a04395c3.1367258255.git.yann.morin.1998@free.fr>
 <517EC9C7.9000903@infradead.org>
 <1367272454.18069.191@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367272454.18069.191@driftwood>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob, All,

On Mon, Apr 29, 2013 at 04:54:14PM -0500, Rob Landley wrote:
> On 04/29/2013 02:28:07 PM, Randy Dunlap wrote:
> >On 04/29/13 10:59, Yann E. MORIN wrote:
> >> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> >>
> >> The C++ compiler is more strict in that it refuses to assign
> >> a void* to a struct list_head*.
> 
> Given that the code _isn't_ C++ (because C is not a subset of C++ but a
> separate langauge in its own right where "throw" is a legitimate variable
> name and so on), how is this an issue?

It's an issue because the xconfig frontends is qconf, which as the name
implies is using Qt, which *is* C++, and includes list.h.

So, list.h is included by both by C and C++ code.

So yes, list.h can be compiled by a C++ compiler.

Now, granted: list.h should all be enclosed in:
    ifdef __cpluplus
    extern "C" {
    endif
    ...
    ifdef __cpluplus
    }
    endif

Was that the fix you were suggesting between the lines? ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
