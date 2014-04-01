Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaDAAvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:51:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56829 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaDAAvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140328084749.GA11688@stefanha-thinkpad.redhat.com>
References: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com>
 <20140327064158.GA17563@redhat.com> <87y4zwt7mu.fsf@blackfin.pond.sub.org>
 <20140327081040.GA21756@redhat.com> <20140327085347.GB9580@stefanha-thinkpad.redhat.com>
 <CAMrG31wx5WLrFMmGg-uasugS+S=e8T156ZPuEofRJeVB-4fVeQ@mail.gmail.com>
 <53351E2C.3070508@msgid.tls.msk.ru> <20140328084749.GA11688@stefanha-thinkpad.redhat.com>
From: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
Date: Mon, 31 Mar 2014 21:51:23 -0300
Message-ID: <CAMrG31ykbYAChLhF5qoUUCFU-tpdxNd5mcWyVOW7DuV-USEHrg@mail.gmail.com>
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

Thanks Stefan and thanks Michael also.

That situation regarding the IRC was very special, since i didnt
wanted to tell Michael "hey, everyone in the mailing list got it and
im here chatting with you and you didn't" so i assumed the IRC was
9999999999999 times more pro than the mailing list so i decided to
keep my head down and assume the communication error was on my side.

Still, IMHO, i really believe that if you are a user willing to give
KVM a chance enought to make a query on the IRC, you might feel you
are not geek enought to be there, and i dont mean be there on IRC, but
trying to use the community to support you while you try KVM.

In my case, while was very important to understant what were my
chances regarding this issue, i knew i would find my answer no matter
what because i was decided to find it, i could get mad with 10.5K
guests running on my back, yes my experience was more from the "virsh
stop; virsh start" side, but still i felt i needed you guys to try to
find this out.

Again, thanks to everyone.

best.
Alejandro Comisario


On Fri, Mar 28, 2014 at 5:47 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Fri, Mar 28, 2014 at 11:01:00AM +0400, Michael Tokarev wrote:
>> 27.03.2014 20:14, Alejandro Comisario wrote:
>> > Seems like virtio (kvm 1.0) doesnt expose timeout on the guest side
>> > (ubuntu 12.04 on host and guest).
>> > So, how can i adjust the tinmeout on the guest ?
>>
>> After a bit more talks on IRC yesterday, it turned out that the situation
>> is _much_ more "interesting" than originally described.  The OP claims to
>> have 10500 guests running off an NFS server, and that after NFS server
>> downtime, the "backing files" were disappeared (whatever it means), so
>> they had to restore those files.  More, the OP didn't even bother to look
>> at the guest's dmesg, being busy rebooting all 10500 guests.
>>
>> > This solution is the most logical one, but i cannot apply it!
>> > thanks for all the responses!
>>
>> I suggested the OP to actually describe the _real_ situation, instead of
>> giving random half-pictures, and actually take a look at the actual problem
>> as reported in various places (most importantly the guest kernel log), and
>> reoirt _those_ hints to the list.  I also mentioned that, at least for some
>> NFS servers, if a client has a file open on the server, and this file is
>> deleted, the server will report error to the client when client tries to
>> access that file, and this has nothing at all to do with timeouts of any
>> kind.
>
> Thanks for the update and for taking time to help on IRC.  I feel you're
> being harsh on Alejandro though.
>
> Improving the quality of bug reports is important but it shouldn't be at
> the expense of quality of communication.  We can't assume that everyone
> is an expert in troubleshooting KVM or Linux.  Therefore we can't blame
> them, which will only drive people away and detract from the community.
>
> TL;DR post logs and error messages +1, berate him -1
>
> Stefan
