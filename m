Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaEIDeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:34:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbaEIDen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:34:43 -0400
Date: Fri, 9 May 2014 11:21:43 +0800
From: Dave Young <dyoung@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kaslr should avoid setup_data region
Message-ID: <20140509032143.GA3087@darkstar.nay.redhat.com>
References: <20140424023544.GA2180@darkstar.nay.redhat.com>
 <CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
 <20140424025016.GB2180@darkstar.nay.redhat.com>
 <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
 <20140508094606.GE3320@darkstar.nay.redhat.com>
 <CAGXu5j+VbEYWH80mvY3wQscqqfkDpKkKv81xQa-qmUz-mqHF2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+VbEYWH80mvY3wQscqqfkDpKkKv81xQa-qmUz-mqHF2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 at 12:31pm, Kees Cook wrote:
> On Thu, May 8, 2014 at 2:46 AM, Dave Young <dyoung@redhat.com> wrote:
> > On 04/24/14 at 03:50pm, Kees Cook wrote:
> >> On Wed, Apr 23, 2014 at 7:50 PM, Dave Young <dyoung@redhat.com> wrote:
> >> > On 04/23/14 at 07:43pm, Kees Cook wrote:
> >> >> On Wed, Apr 23, 2014 at 7:35 PM, Dave Young <dyoung@redhat.com> wrote:
> >> >> > Hello Kees
> >> >> >
> >> >> > I'm worrying that setup_data regions could be overwitten by randomize
> >> >> > kernel base. Would you like to fix it in kaslr code?
> >> >> >
> >> >> > One problem is there could be a lot of setup_data regions but current
> >> >> > mem_avoid is an fixed array.
> >> >>
> >> >> Sure, can you give me some examples? Seems like it shouldn't be too
> >> >> hard to have the mem_avoid logic walk additional areas.
> >> >
> >> > Great, To walk through the list just like the function parse_setup_data in
> >> > arch/x86/kernel/setup.c
> >
> > One problem for me is that I am not sure how to read the setup_data memory
> > and iterate it, I think early_ioremap is not available that early. BTW the
> > setup_data region could be above 4G.
> >
> > Appreciate for any hints.
> 
> Hm, I'm not sure. The kASLR code only deals with memory that has been
> set up during the physical/virtual identity mapping.
> 

So will dereference them directly and ignore setup_data which is above 4G.

Thanks
Dave
