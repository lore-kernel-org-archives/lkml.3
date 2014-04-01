Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaDAOKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:10:00 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:38224 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAOJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:09:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140401135242.GC7972@stefanha-thinkpad.redhat.com>
References: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com>
 <20140327064158.GA17563@redhat.com> <87y4zwt7mu.fsf@blackfin.pond.sub.org>
 <20140327081040.GA21756@redhat.com> <20140327085347.GB9580@stefanha-thinkpad.redhat.com>
 <CAMrG31wx5WLrFMmGg-uasugS+S=e8T156ZPuEofRJeVB-4fVeQ@mail.gmail.com>
 <53351E2C.3070508@msgid.tls.msk.ru> <20140328084749.GA11688@stefanha-thinkpad.redhat.com>
 <CAMrG31ykbYAChLhF5qoUUCFU-tpdxNd5mcWyVOW7DuV-USEHrg@mail.gmail.com> <20140401135242.GC7972@stefanha-thinkpad.redhat.com>
From: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
Date: Tue, 1 Apr 2014 11:09:37 -0300
Message-ID: <CAMrG31zp5Sq4j7O+1AsaVNLpyc2QpfRU5FEFDmS7hyOSELS50Q@mail.gmail.com>
Subject: Re: [Qemu-devel] Massive read only kvm guests when backing file was missing
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        ghammer@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conclusion is that the backing file stored on NFS that is the same
for all 950 hosts / 10500 guests was deleted and immediatelly raised a
read-only filesystem on the guest, seems that there's no way to avoid
that.

We developed a script to recover from that scenario if the same happens.
Basically doing:

* virsh stop
* qemu-ndb connect
* fsck
* qemu-ndb disconnect
* virsh start

best regards.


Alejandro Comisario
MercadoLibre Cloud Services
Arias 3751, Piso 7 (C1430CRG)
Ciudad de Buenos Aires - Argentina
Cel: +549(11) 15-3770-1857
Tel : +54(11) 4640-8443


On Tue, Apr 1, 2014 at 10:52 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Mon, Mar 31, 2014 at 09:51:23PM -0300, Alejandro Comisario wrote:
>> Again, thanks to everyone.
>
> Did you reach a conclusion or is there still a problem that might be a
> bug in KVM?
>
> Stefan
