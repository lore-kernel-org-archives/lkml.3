Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaIAK1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:27:14 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46568 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaIAK1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <54044C5C.9010305@intel.com>
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
 <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
 <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
 <53FF0765.3050509@intel.com> <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com>
 <CAPybu_1UytoxXk-t7u_3vQ6KL-5DmVUz1u5PiDLysBCvgit--A@mail.gmail.com>
 <53FF48B1.5090901@intel.com> <CAPybu_2rgn-DEUKfdmGsaAsFSQJ_zz6fsdnD0dHmyCPW4B-+WA@mail.gmail.com>
 <54009A50.9010707@intel.com> <CAPybu_2ZQ9iPA_FfYn2Mqg5vXn40HuFCcVv1Zg900YavKCDxUQ@mail.gmail.com>
 <CAPybu_3qmtob-uJhcUwEETcM7cXPxOm3-zOjNFLub31mQDdABQ@mail.gmail.com> <54044C5C.9010305@intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 1 Sep 2014 12:26:51 +0200
Message-ID: <CAPybu_3jtJDXw1rJOQVoc2G9UmDXqeaLW-aNvfO=y306XQoXjQ@mail.gmail.com>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, it is hard to say. rc2 without the patch showed more warnings,
but never crashed badly (queuecommand_lck....).

The sample size is not big enough. maybe rc2 also has the
queuecommand_lck bug, but I havent hit it.

On Mon, Sep 1, 2014 at 12:37 PM, Mathias Nyman <mathias.nyman@intel.com> wrote:
> On 09/01/2014 12:36 PM, Ricardo Ribalda Delgado wrote:
>> After some time of use (one hour or so) my system started to behave
>> "weird". I did check  dmesg and I was receiving the following line
>> again and again:
>>
>> usb-storage: Error in queuecommand_lck: us->sfb= ffff8805bd61ccc0
>>
>> I did disconnect the usb device and the whole computer crashed :S
>>
>
> Ok, thanks.
>
> Would you say things work better after the patch?
>
> I still think the patch solves part of the issue, i.e. how we handle halted endpoints
> in reset, but I don't know the reason why the endpoints stall in the first place
>
> -Mathias
>
>



-- 
Ricardo Ribalda
