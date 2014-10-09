Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbaJIOQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:16:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:61577 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaJIOQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,685,1406617200"; 
   d="scan'208";a="602836649"
Message-ID: <1412864192.28467.72.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH 03/12] serial_core: Handle TIOC[GS]RS485 ioctls.
From: Alan Cox <alan@linux.intel.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 09 Oct 2014 15:16:32 +0100
In-Reply-To: <CAPybu_3b6epYcQ1c0L0E1so7BNJ7DndA4E2nHDfj8OYjR3u0Zw@mail.gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1412798258-23655-4-git-send-email-ricardo.ribalda@gmail.com>
	 <1412799101.28467.68.camel@acox1-desk.ger.corp.intel.com>
	 <CAPybu_3b6epYcQ1c0L0E1so7BNJ7DndA4E2nHDfj8OYjR3u0Zw@mail.gmail.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 10:07 +0200, Ricardo Ribalda Delgado wrote:
> Hello Alan
> 
> >
> > What is the locking between setting/getting/driver use of the config ?
> > This really needs a lock (termios sem I think is perhaps appropriate
> > given when the values are normally referenced).
> 
> I tried implementing it with the sermios sem
> ((&(uart_port)->state->port.tty->termios_rwsem)), but some drivers
> access the rs485 structure inside their irq handler. So I have see
> options here
> 
> 1) Protect the structure with uart_port->lock spinlock
> 2) Assume that an assignment is atomic on critical sections where I
> cannot hold the rwsem.
> 
> I think 1) is more correct. Any issues that I continue in this
> direction? Any better idea?

For uart #1 sounds right to me too.

Alan


