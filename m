Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3ANHi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:38:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:30544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3ANHiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:38:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,466,1355068800"; 
   d="scan'208";a="6581671"
Date: Mon, 14 Jan 2013 15:38:21 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v12 0/8] pv event to notify host when the
 guest is panicked
Message-ID: <20130114073821.GE14958@localhost.localdomain>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
 <20121220075359.GF7141@localhost.localdomain>
 <20121225215205.GA6222@amt.cnet>
MIME-Version: 1.0
In-Reply-To: <20121225215205.GA6222@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 15:37:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 15:37:42,
	Serialize complete at 2013/01/14 15:37:42
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

Sorry for the late reply.

On Tue, Dec 25, 2012 at 07:52:05PM -0200, Marcelo Tosatti wrote:
> On Thu, Dec 20, 2012 at 03:53:59PM +0800, Hu Tao wrote:
> > Hi,
> > 
> > Any comments?
> 
> As far as i can see, items 2 and 3 of
> 
> https://lkml.org/lkml/2012/11/12/588
> 
> Have not been addressed.
> 
> https://lkml.org/lkml/2012/11/20/653 contains discussions on those
> items.
> 
> 2) Format of the interface for other architectures (you can choose
> a different KVM supported architecture and write an example). It was
> your choice to choose an I/O port, which is x86 specific.

Unfortunately I don't have hardware other than x86 in hand to test it.

> 
> 3) Clear/documented management interface for the feature.

Patch #8 adds a document to describe the usage of pv event. But as you
are asking again, I must be misunderstanding the meaning of management
interface. Can you clarify it?

> 
> Note 3 is for management, not the guest<->host interface.
> 
> > On Wed, Dec 12, 2012 at 02:13:43PM +0800, Hu Tao wrote:
> > > This series implements a new interface, kvm pv event, to notify host when
> > > some events happen in guest. Right now there is one supported event: guest
> > > panic.
> > > 
> > > changes from v11:
> > > 
> > >   - add a new patch 'save/load cpu runstate'
> > >   - fix a bug of null-dereference when no -machine option is supplied
> > >   - reserve RUN_STATE_GUEST_PANICKED during migration
> > >   - add doc of enable_pv_event option
> > >   - disable reboot-on-panic if pv_event is on
> > > 
> > > v11: http://lists.gnu.org/archive/html/qemu-devel/2012-10/msg04361.html
> > > 
> > > Hu Tao (7):
> > >   save/load cpu runstate
> > >   update kernel headers
> > >   add a new runstate: RUN_STATE_GUEST_PANICKED
> > >   add a new qevent: QEVENT_GUEST_PANICKED
> > >   introduce a new qom device to deal with panicked event
> > >   allower the user to disable pv event support
> > >   pv event: add document to describe the usage
> > > 
> > > Wen Congyang (1):
> > >   start vm after resetting it
> > > 
> > >  block.h                          |   2 +
> > >  docs/pv-event.txt                |  17 ++++
> > >  hw/kvm/Makefile.objs             |   2 +-
> > >  hw/kvm/pv_event.c                | 197 +++++++++++++++++++++++++++++++++++++++
> > >  hw/pc_piix.c                     |  11 +++
> > >  kvm-stub.c                       |   4 +
> > >  kvm.h                            |   2 +
> > >  linux-headers/asm-x86/kvm_para.h |   1 +
> > >  linux-headers/linux/kvm_para.h   |   6 ++
> > >  migration.c                      |   7 +-
> > >  monitor.c                        |   6 +-
> > >  monitor.h                        |   1 +
> > >  qapi-schema.json                 |   6 +-
> > >  qemu-config.c                    |   4 +
> > >  qemu-options.hx                  |   3 +-
> > >  qmp.c                            |   5 +-
> > >  savevm.c                         |   1 +
> > >  sysemu.h                         |   2 +
> > >  vl.c                             |  52 ++++++++++-
> > >  19 files changed, 312 insertions(+), 17 deletions(-)
> > >  create mode 100644 docs/pv-event.txt
> > >  create mode 100644 hw/kvm/pv_event.c
> > > 
> > > -- 
> > > 1.8.0.1.240.ge8a1f5a
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
