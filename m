Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3CIVeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 16:34:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50266 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab3CIVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 16:34:33 -0500
X-Sasl-enc: cBQbEJxsOX7aTr9VEGocW9LosGH7RFBelljG9sTb5SFA 1362864871
Date: Sat, 9 Mar 2013 18:34:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Artem Savkov <artem.savkov@gmail.com>
Subject: Re: [PATCH 1/1] thinkpad-acpi: kill hotkey_thread_mutex
Message-ID: <20130309213428.GB7559@khazad-dum.debian.net>
References: <20130305174838.GA7276@redhat.com>
 <CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com>
 <20130305180542.GA12738@redhat.com>
 <CACBanvr7XvXbFjphpRwKHHJKzVuA-s6sF-qkPiizBV3+uqzpJw@mail.gmail.com>
 <20130305232603.GA16045@khazad-dum.debian.net>
 <20130306154420.GA7697@redhat.com>
 <20130306233232.GA12645@khazad-dum.debian.net>
 <20130307175305.GA15631@redhat.com>
 <20130307175359.GB15631@redhat.com>
 <CACBanvqP0jx_d-LtV5+fRD7M698M_b6j0Sv=v0uoTBpjEusQCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvqP0jx_d-LtV5+fRD7M698M_b6j0Sv=v0uoTBpjEusQCw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Mar 2013, Mandeep Singh Baines wrote:
> On Thu, Mar 7, 2013 at 9:53 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > hotkey_kthread() does try_to_freeze() under hotkey_thread_mutex.
> >
> > We can simply kill this mutex, hotkey_poll_stop_sync() does not need
> > to serialize with hotkey_kthread(). When kthread_stop() returns the
> > thread is already dead, it called do_exit()->complete_vfork_done().
> >
> > Reported-by: Artem Savkov <artem.savkov@gmail.com>
> > Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> 
> Reviewed-by: Mandeep Singh Baines <msb@chromium.org>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
