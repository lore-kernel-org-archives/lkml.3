Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbbAAPe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:34:58 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:43345 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbAAPe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:34:57 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: m68k: atari: atakeyb.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 16:37:57 +0100
Message-Id: <1420126677-27948-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
atari_kbd_leds() ikbd_exec() ikbd_mem_read() ikbd_mem_write()
ikbd_clock_get() ikbd_clock_set() ikbd_pause() ikbd_resume()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/m68k/atari/atakeyb.c |   66 ---------------------------------------------
 1 file changed, 66 deletions(-)

diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 95022b0..ad91969 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -430,14 +430,6 @@ void ikbd_mouse_y0_top(void)
 }
 EXPORT_SYMBOL(ikbd_mouse_y0_top);
 
-/* Resume */
-void ikbd_resume(void)
-{
-	static const char cmd[1] = { 0x11 };
-
-	ikbd_write(cmd, 1);
-}
-
 /* Disable mouse */
 void ikbd_mouse_disable(void)
 {
@@ -447,14 +439,6 @@ void ikbd_mouse_disable(void)
 }
 EXPORT_SYMBOL(ikbd_mouse_disable);
 
-/* Pause output */
-void ikbd_pause(void)
-{
-	static const char cmd[1] = { 0x13 };
-
-	ikbd_write(cmd, 1);
-}
-
 /* Set joystick event reporting */
 void ikbd_joystick_event_on(void)
 {
@@ -502,56 +486,6 @@ void ikbd_joystick_disable(void)
 	ikbd_write(cmd, 1);
 }
 
-/* Time-of-day clock set */
-void ikbd_clock_set(int year, int month, int day, int hour, int minute, int second)
-{
-	char cmd[7] = { 0x1B, year, month, day, hour, minute, second };
-
-	ikbd_write(cmd, 7);
-}
-
-/* Interrogate time-of-day clock */
-void ikbd_clock_get(int *year, int *month, int *day, int *hour, int *minute, int second)
-{
-	static const char cmd[1] = { 0x1C };
-
-	ikbd_write(cmd, 1);
-}
-
-/* Memory load */
-void ikbd_mem_write(int address, int size, char *data)
-{
-	panic("Attempt to write data into keyboard memory");
-}
-
-/* Memory read */
-void ikbd_mem_read(int address, char data[6])
-{
-	char cmd[3] = { 0x21, address>>8, address&0xFF };
-
-	ikbd_write(cmd, 3);
-
-	/* receive data and put it in data */
-}
-
-/* Controller execute */
-void ikbd_exec(int address)
-{
-	char cmd[3] = { 0x22, address>>8, address&0xFF };
-
-	ikbd_write(cmd, 3);
-}
-
-/* Status inquiries (0x87-0x9A) not yet implemented */
-
-/* Set the state of the caps lock led. */
-void atari_kbd_leds(unsigned int leds)
-{
-	char cmd[6] = {32, 0, 4, 1, 254 + ((leds & 4) != 0), 0};
-
-	ikbd_write(cmd, 6);
-}
-
 /*
  * The original code sometimes left the interrupt line of
  * the ACIAs low forever. I hope, it is fixed now.
-- 
1.7.10.4

