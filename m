Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaEGPah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:30:37 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59776 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaEGPae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <536A1B91.2070103@redhat.com>
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>
	<53636B1D.8030405@redhat.com>
	<CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>
	<5363BF42.9020505@redhat.com>
	<CAHqbYQvjBmeu2_WzrSesGA=PH+8-ZfYxdmKxvsPfHRYNEcObAg@mail.gmail.com>
	<jpgzjj0xbxl.fsf@nelium.bos.redhat.com>
	<CAHqbYQuaaUaGTahryghh0nX99msMgeNQr=yv34mbgDJbFeSCbw@mail.gmail.com>
	<CAESbUUzDm0REihDHinZ+fmQL8MWqn4kYCY8mQaVEnmVr4hh7NA@mail.gmail.com>
	<CAHqbYQuv73Wm_9p-_yhYn5C5K9Ag+8Az+sJ_-WEnk9u9Z586Ww@mail.gmail.com>
	<5369F5B0.7050307@redhat.com>
	<CAESbUUyQJ=BF1otV7XY2VpiM5TH6AxMMqGWCwO0+Mk_51sX_BA@mail.gmail.com>
	<536A1AEA.9020309@redhat.com>
	<536A1B91.2070103@redhat.com>
Date: Wed, 7 May 2014 18:30:32 +0300
Message-ID: <CAESbUUyxxLLdmN5oV+NoOF+4z9-xAc6AOXPD7_XhSQ9sKvZYBA@mail.gmail.com>
Subject: Re: KVM Nested L2 guest startup problems
From: Abel Gordon <abel@stratoscale.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hu Yaohui <loki2441@gmail.com>, Bandan Das <bsd@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Muli Ben-Yehuda <muli@stratoscale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 2:40 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 07/05/2014 13:37, Paolo Bonzini ha scritto:
>
>> Il 07/05/2014 13:16, Abel Gordon ha scritto:
>>>>
>>>> > PLE should be left enabled, I think.
>>>
>>> Well... the PLE settings L0 uses to run  L1 (vmcs01) may be different
>>> than the PLE settings L1 configured to run  L2 (vmcs12).
>>> For example, L0 can use a  ple_gap to run L1 that is bigger than the
>>> ple_gap L1 configured to run L2. Or  L0 can use a ple_window to run L1
>>> that is smaller than the ple_window L1 configured to run L2.
>>
>>
>> That's correct.  We should leave PLE enabled while running L2, but hide
>> the feature altogether from L1.
>
>
> ... which we already do.  The only secondary execution controls we allow are
> APIC page, unrestricted guest, WBINVD exits, and of course EPT.

But we don't verify if L1  tries to enable the feature for L1 (even if
it's not exposed)... Or do we ?
