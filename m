Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaAMS7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:59:24 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:62209 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAMS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:59:22 -0500
From: Laszlo Papp <lpapp@kde.org>
To: linus.walleij@linaro.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] pinctrl: typo and grammar fixes
Date: Mon, 13 Jan 2014 18:54:11 +0000
Message-Id: <1389639251-10360-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had been trying to learn a bit more about the pinctrl subsystem, and I
realized several typos and grammar issues while going through the documentation.
I have probably not caught all the possible issues, but this change is
addressing several places for improvement.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 Documentation/pinctrl.txt | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index a7929cb..23f1590 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -18,7 +18,7 @@ Definition of PIN CONTROLLER:
 
 - A pin controller is a piece of hardware, usually a set of registers, that
   can control PINs. It may be able to multiplex, bias, set load capacitance,
-  set drive strength etc for individual pins or groups of pins.
+  set drive strength, etc. for individual pins or groups of pins.
 
 Definition of PIN:
 
@@ -90,7 +90,7 @@ selected drivers, you need to select them from your machine's Kconfig entry,
 since these are so tightly integrated with the machines they are used on.
 See for example arch/arm/mach-u300/Kconfig for an example.
 
-Pins usually have fancier names than this. You can find these in the dataheet
+Pins usually have fancier names than this. You can find these in the datasheet
 for your chip. Notice that the core pinctrl.h file provides a fancy macro
 called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
 the pins from 0 in the upper left corner to 63 in the lower right corner.
@@ -185,7 +185,7 @@ static struct pinctrl_desc foo_desc = {
 };
 
 The pin control subsystem will call the .get_groups_count() function to
-determine total number of legal selectors, then it will call the other functions
+determine the total number of legal selectors, then it will call the other functions
 to retrieve the name and pins of the group. Maintaining the data structure of
 the groups is up to the driver, this is just a simple example - in practice you
 may need more entries in your group structure, for example specific register
@@ -195,7 +195,7 @@ ranges associated with each group and so on.
 Pin configuration
 =================
 
-Pins can sometimes be software-configured in an various ways, mostly related
+Pins can sometimes be software-configured in various ways, mostly related
 to their electronic properties when used as inputs or outputs. For example you
 may be able to make an output pin high impedance, or "tristate" meaning it is
 effectively disconnected. You may be able to connect an input pin to VDD or GND
@@ -291,7 +291,7 @@ Since the pin controller subsystem have its pinspace local to the pin
 controller we need a mapping so that the pin control subsystem can figure out
 which pin controller handles control of a certain GPIO pin. Since a single
 pin controller may be muxing several GPIO ranges (typically SoCs that have
-one set of pins but internally several GPIO silicon blocks, each modelled as
+one set of pins, but internally several GPIO silicon blocks, each modelled as
 a struct gpio_chip) any number of GPIO ranges can be added to a pin controller
 instance like this:
 
@@ -373,9 +373,9 @@ will be called on that specific pin controller.
 
 For all functionalities dealing with pin biasing, pin muxing etc, the pin
 controller subsystem will look up the corresponding pin number from the passed
-in gpio number, and use the range's internals to retrive a pin number. After
+in gpio number, and use the range's internals to retrieve a pin number. After
 that, the subsystem passes it on to the pin control driver, so the driver
-will get an pin number into its handled number range. Further it is also passed
+will get a pin number into its handled number range. Further it is also passed
 the range ID value, so that the pin controller knows which range it should
 deal with.
 
@@ -430,8 +430,8 @@ pins you see some will be taken by things like a few VCC and GND to feed power
 to the chip, and quite a few will be taken by large ports like an external
 memory interface. The remaining pins will often be subject to pin multiplexing.
 
-The example 8x8 PGA package above will have pin numbers 0 thru 63 assigned to
-its physical pins. It will name the pins { A1, A2, A3 ... H6, H7, H8 } using
+The example 8x8 PGA package above will have pin numbers 0 through 63 assigned
+to its physical pins. It will name the pins { A1, A2, A3 ... H6, H7, H8 } using
 pinctrl_register_pins() and a suitable data set as shown earlier.
 
 In this 8x8 BGA package the pins { A8, A7, A6, A5 } can be used as an SPI port
@@ -442,7 +442,7 @@ we cannot use the SPI port and I2C port at the same time. However in the inside
 of the package the silicon performing the SPI logic can alternatively be routed
 out on pins { G4, G3, G2, G1 }.
 
-On the botton row at { A1, B1, C1, D1, E1, F1, G1, H1 } we have something
+On the bottom row at { A1, B1, C1, D1, E1, F1, G1, H1 } we have something
 special - it's an external MMC bus that can be 2, 4 or 8 bits wide, and it will
 consume 2, 4 or 8 pins respectively, so either { A1, B1 } are taken or
 { A1, B1, C1, D1 } or all of them. If we use all 8 bits, we cannot use the SPI
@@ -549,7 +549,7 @@ Assumptions:
 
 We assume that the number of possible function maps to pin groups is limited by
 the hardware. I.e. we assume that there is no system where any function can be
-mapped to any pin, like in a phone exchange. So the available pins groups for
+mapped to any pin, like in a phone exchange. So the available pin groups for
 a certain function will be limited to a few choices (say up to eight or so),
 not hundreds or any amount of choices. This is the characteristic we have found
 by inspecting available pinmux hardware, and a necessary assumption since we
@@ -564,7 +564,7 @@ The pinmux core takes care of preventing conflicts on pins and calling
 the pin controller driver to execute different settings.
 
 It is the responsibility of the pinmux driver to impose further restrictions
-(say for example infer electronic limitations due to load etc) to determine
+(say for example infer electronic limitations due to load, etc.) to determine
 whether or not the requested function can actually be allowed, and in case it
 is possible to perform the requested mux setting, poke the hardware so that
 this happens.
@@ -755,7 +755,7 @@ Pin control interaction with the GPIO subsystem
 Note that the following implies that the use case is to use a certain pin
 from the Linux kernel using the API in <linux/gpio.h> with gpio_request()
 and similar functions. There are cases where you may be using something
-that your datasheet calls "GPIO mode" but actually is just an electrical
+that your datasheet calls "GPIO mode", but actually is just an electrical
 configuration for a certain device. See the section below named
 "GPIO mode pitfalls" for more details on this scenario.
 
@@ -871,7 +871,7 @@ hardware and shall be put into different subsystems:
 
 - Registers (or fields within registers) that control muxing of signals
   from various other HW blocks (e.g. I2C, MMC, or GPIO) onto pins should
-  be exposed through the pinctrl subssytem, as mux functions.
+  be exposed through the pinctrl subsystem, as mux functions.
 
 - Registers (or fields within registers) that control GPIO functionality
   such as setting a GPIO's output value, reading a GPIO's input value, or
@@ -895,7 +895,7 @@ Example: a pin is usually muxed in to be used as a UART TX line. But during
 system sleep, we need to put this pin into "GPIO mode" and ground it.
 
 If you make a 1-to-1 map to the GPIO subsystem for this pin, you may start
-to think that you need to come up with something real complex, that the
+to think that you need to come up with something really complex, that the
 pin shall be used for UART TX and GPIO at the same time, that you will grab
 a pin control handle and set it to a certain state to enable UART TX to be
 muxed in, then twist it over to GPIO mode and use gpio_direction_output()
@@ -964,12 +964,12 @@ GPIO mode.
 This will give the desired effect without any bogus interaction with the
 GPIO subsystem. It is just an electrical configuration used by that device
 when going to sleep, it might imply that the pin is set into something the
-datasheet calls "GPIO mode" but that is not the point: it is still used
+datasheet calls "GPIO mode", but that is not the point: it is still used
 by that UART device to control the pins that pertain to that very UART
 driver, putting them into modes needed by the UART. GPIO in the Linux
 kernel sense are just some 1-bit line, and is a different use case.
 
-How the registers are poked to attain the push/pull and output low
+How the registers are poked to attain the push or pull, and output low
 configuration and the muxing of the "u0" or "gpio-mode" group onto these
 pins is a question for the driver.
 
@@ -977,7 +977,7 @@ Some datasheets will be more helpful and refer to the "GPIO mode" as
 "low power mode" rather than anything to do with GPIO. This often means
 the same thing electrically speaking, but in this latter case the
 software engineers will usually quickly identify that this is some
-specific muxing/configuration rather than anything related to the GPIO
+specific muxing or configuration rather than anything related to the GPIO
 API.
 
 
@@ -1024,8 +1024,7 @@ up the device struct (just like with clockdev or regulators). The function name
 must match a function provided by the pinmux driver handling this pin range.
 
 As you can see we may have several pin controllers on the system and thus
-we need to specify which one of them that contain the functions we wish
-to map.
+we need to specify which one of them contains the functions we wish to map.
 
 You register this pinmux mapping to the pinmux subsystem by simply:
 
@@ -1254,10 +1253,10 @@ The semantics of the pinctrl APIs are:
   pinctrl_get().
 
 - pinctrl_lookup_state() is called in process context to obtain a handle to a
-  specific state for a the client device. This operation may be slow too.
+  specific state for a client device. This operation may be slow, too.
 
 - pinctrl_select_state() programs pin controller hardware according to the
-  definition of the state as given by the mapping table. In theory this is a
+  definition of the state as given by the mapping table. In theory, this is a
   fast-path operation, since it only involved blasting some register settings
   into hardware. However, note that some pin controllers may have their
   registers on a slow/IRQ-based bus, so client devices should not assume they
-- 
1.8.5.2

