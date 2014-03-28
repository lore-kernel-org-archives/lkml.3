Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaC1Ir5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:47:57 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49459 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaC1Irx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:47:53 -0400
Date: Fri, 28 Mar 2014 09:47:49 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alejandro Comisario <alejandro.comisario@mercadolibre.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, ghammer@redhat.com,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        Markus Armbruster <armbru@redhat.com>
Subject: Re: [Qemu-devel] Massive read only kvm guests when backing file was
 missing
Message-ID: <20140328084749.GA11688@stefanha-thinkpad.redhat.com>
References: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com>
 <20140327064158.GA17563@redhat.com>
 <87y4zwt7mu.fsf@blackfin.pond.sub.org>
 <20140327081040.GA21756@redhat.com>
 <20140327085347.GB9580@stefanha-thinkpad.redhat.com>
 <CAMrG31wx5WLrFMmGg-uasugS+S=e8T156ZPuEofRJeVB-4fVeQ@mail.gmail.com>
 <53351E2C.3070508@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53351E2C.3070508@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 11:01:00AM +0400, Michael Tokarev wrote:
> 27.03.2014 20:14, Alejandro Comisario wrote:
> > Seems like virtio (kvm 1.0) doesnt expose timeout on the guest side
> > (ubuntu 12.04 on host and guest).
> > So, how can i adjust the tinmeout on the guest ?
> 
> After a bit more talks on IRC yesterday, it turned out that the situation
> is _much_ more "interesting" than originally described.  The OP claims to
> have 10500 guests running off an NFS server, and that after NFS server
> downtime, the "backing files" were disappeared (whatever it means), so
> they had to restore those files.  More, the OP didn't even bother to look
> at the guest's dmesg, being busy rebooting all 10500 guests.
> 
> > This solution is the most logical one, but i cannot apply it!
> > thanks for all the responses!
> 
> I suggested the OP to actually describe the _real_ situation, instead of
> giving random half-pictures, and actually take a look at the actual problem
> as reported in various places (most importantly the guest kernel log), and
> reoirt _those_ hints to the list.  I also mentioned that, at least for some
> NFS servers, if a client has a file open on the server, and this file is
> deleted, the server will report error to the client when client tries to
> access that file, and this has nothing at all to do with timeouts of any
> kind.

Thanks for the update and for taking time to help on IRC.  I feel you're
being harsh on Alejandro though.

Improving the quality of bug reports is important but it shouldn't be at
the expense of quality of communication.  We can't assume that everyone
is an expert in troubleshooting KVM or Linux.  Therefore we can't blame
them, which will only drive people away and detract from the community.

TL;DR post logs and error messages +1, berate him -1

Stefan
