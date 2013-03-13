Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab3CMXQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:16:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38785 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab3CMXQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:16:06 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Subject: RE: [PATCH 2/3] leds: add LED Trigger for camera function
Thread-Topic: [PATCH 2/3] leds: add LED Trigger for camera function
Thread-Index: Ac4PRVGs1jaCsF+dQo64EeKjGOQWtwPxIECAAE2KISA=
Date: Wed, 13 Mar 2013 23:16:01 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E487A0@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F79273676@DQHE02.ent.ti.com>
 <CAK5ve-KT3NEv=MYv2ZQ9YQ8L-TS9KFaL0VNXzO7KoG9gvSRGcg@mail.gmail.com>
In-Reply-To: <CAK5ve-KT3NEv=MYv2ZQ9YQ8L-TS9KFaL0VNXzO7KoG9gvSRGcg@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#if defined(CONFIG_LEDS_TRIGGER_CAMERA) ||
> defined(CONFIG_LEDS_TRIGGER_CAMERA_MODULE)
> > +extern void ledtrig_flash_ctrl(bool on);
> > +extern void ledtrig_torch_ctrl(bool on);
> > +#else
> > +#define ledtrig_flash_ctrl(x) do {} while(0)
> > +#define ledtrig_torch_ctrl(x) do {} while(0)
> 
> It's better don't use #define macros but use real empty functions like
> this:
> static inline void ledtrig_flash_ctrl(bool on)
> {
>         return;
> }

I agree, but other trigger functions are declared as do-while definition.
So I would let them unify if it's not critical.
I'd like to have your opinion, which is better.

Thanks,
Milo
