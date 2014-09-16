Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaIPWlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:41:07 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39554 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaIPWlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:41:05 -0400
Date: Tue, 16 Sep 2014 15:40:42 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 4/4] mfd: max77693: Update DT binding to support haptic
Message-ID: <20140916224042.GR25162@lee--X1>
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
 <1410440062-19963-5-git-send-email-jaewon02.kim@samsung.com>
 <20140915230043.GI25162@lee--X1>
 <5417EDFE.7030700@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5417EDFE.7030700@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Jaewon Kim wrote:
> 2014년 09월 16일 08:00에 Lee Jones 이(가) 쓴 글:
> >On Thu, 11 Sep 2014, Jaewon Kim wrote:
> >
> >>This patch add haptic DT binding documentation and example
> >>to support haptic driver in max77693 Multifunction device.
> >>
> >>Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> >>Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> >>---
> >>  Documentation/devicetree/bindings/mfd/max77693.txt |   18 ++++++++++++++++++
> >>  1 file changed, 18 insertions(+)
> >>
> >>diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> >>index 11921cc..d178b9e 100644
> >>--- a/Documentation/devicetree/bindings/mfd/max77693.txt
> >>+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> >>@@ -27,6 +27,17 @@ Optional properties:
> >>  	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> >>+- haptic : The haptic of max77693 have to be instantiated under subnod
> >Perhaps a description as to what "The haptic" is might be handy?
> Ok, I will add description about haptic.
> 
> >
> >s/have/has
> >
> >s/subnod/subnode
> >
> >What do you mean by "under" a subnode?  Do you mean "as a" subnode?

I see what you did here now.  You copied this from the discription
above.  That will also need to be changed.

> >>+  named "haptic" using the following haptic format in example.
> >What is the "haptic format"?  It just looks like a normal node to me.
> >
> >>+  Haptic sensation from motor can be changed by changing a period cycle in pwms.
> >Is "Haptic sensation" a technical term?
> >
> >s/from motor/from a motor/
> >
> >s/changed by changing/changed by varying/
> >
> >s/period cycle/duty cycle/
> >
> >s/in pwms/in the pwms property/
> How is it if I change in this way?
> 
> haptic : Referring to the term Haptic, It is the use of advanced
> vibration patterns
>     and waveforms to convey information to a user or operator.
> 
>     MAX77693 uses PWM and MOTOR in order to give Haptic.
>     The Haptic from a motor can be changed by varying a period/duty
> cycle in pwms.

Hmm... How about:

The MAX77693 haptic device utilises a PWM controlled motor to provide
users with tactile feedback.  PWM period and duty-cycle are varied in
order to provide the approprite level of feedback.

> >>+
> >>+ Required properties:
> >>+	- compatible : Must be "maxim,max77693-hpatic"
> >>+	- haptic-supply : power supply for haptic motor
> >s/for haptic/for the haptic/
> >
> >>+		[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> >>+	- pwms : phandle to the physical PWM device,
> >It's not just the phandle though is it?
> Do you want more description?

Yes please.

> Or it mean the wrong?
> 
> >
> >>+		[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
> >>+
> >>  Example:
> >>  	max77693@66 {
> >>  		compatible = "maxim,max77693";
> >>@@ -52,4 +63,11 @@ Example:
> >>  					regulator-boot-on;
> >>  			};
> >>  		};
> >>+
> >>+		haptic {
> >>+			compatible = "maxim,max77693-haptic";
> >>+			haptic-supply = <&haptic_supply>;
> >>+			pwms = <&pwm 0 40000 0>;
> >>+			pwm-names = "haptic";
> >>+		};
> >>  	};
> 
> Thank you for feedback.
> And plz review "[PATCH v4 3/4] mfd: max77693: add haptic
> of_compatible in mfd_cell".



-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
