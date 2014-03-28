Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaC1HIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:08:09 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:60122 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaC1HIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:08:07 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2014 03:08:07 EDT
Message-ID: <53351E2C.3070508@msgid.tls.msk.ru>
Date: Fri, 28 Mar 2014 11:01:00 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        ghammer@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Subject: Re: [Qemu-devel] Massive read only kvm guests when backing file was
 missing
References: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com> <20140327064158.GA17563@redhat.com> <87y4zwt7mu.fsf@blackfin.pond.sub.org> <20140327081040.GA21756@redhat.com> <20140327085347.GB9580@stefanha-thinkpad.redhat.com> <CAMrG31wx5WLrFMmGg-uasugS+S=e8T156ZPuEofRJeVB-4fVeQ@mail.gmail.com>
In-Reply-To: <CAMrG31wx5WLrFMmGg-uasugS+S=e8T156ZPuEofRJeVB-4fVeQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.03.2014 20:14, Alejandro Comisario wrote:
> Seems like virtio (kvm 1.0) doesnt expose timeout on the guest side
> (ubuntu 12.04 on host and guest).
> So, how can i adjust the tinmeout on the guest ?

After a bit more talks on IRC yesterday, it turned out that the situation
is _much_ more "interesting" than originally described.  The OP claims to
have 10500 guests running off an NFS server, and that after NFS server
downtime, the "backing files" were disappeared (whatever it means), so
they had to restore those files.  More, the OP didn't even bother to look
at the guest's dmesg, being busy rebooting all 10500 guests.

> This solution is the most logical one, but i cannot apply it!
> thanks for all the responses!

I suggested the OP to actually describe the _real_ situation, instead of
giving random half-pictures, and actually take a look at the actual problem
as reported in various places (most importantly the guest kernel log), and
reoirt _those_ hints to the list.  I also mentioned that, at least for some
NFS servers, if a client has a file open on the server, and this file is
deleted, the server will report error to the client when client tries to
access that file, and this has nothing at all to do with timeouts of any
kind.

Thanks,

/mjt
