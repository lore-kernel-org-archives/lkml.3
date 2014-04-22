Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaDVNLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:11:48 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:32871 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaDVNLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:11:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mike Turquette <mturquette@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] clk: Fixup spacing in comments
Date: Tue, 22 Apr 2014 15:11:41 +0200
Message-Id: <1398172302-24379-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove spaces in front of TABs,
- Correct indentation for some CLK_* flag descriptions.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 include/linux/clk-provider.h |   88 +++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 511917416fb0..ec90b8a7806f 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -40,14 +40,14 @@ struct dentry;
  * through the clk_* api.
  *
  * @prepare:	Prepare the clock for enabling. This must not return until
- * 		the clock is fully prepared, and it's safe to call clk_enable.
- * 		This callback is intended to allow clock implementations to
- * 		do any initialisation that may sleep. Called with
- * 		prepare_lock held.
+ *		the clock is fully prepared, and it's safe to call clk_enable.
+ *		This callback is intended to allow clock implementations to
+ *		do any initialisation that may sleep. Called with
+ *		prepare_lock held.
  *
  * @unprepare:	Release the clock from its prepared state. This will typically
- * 		undo any work done in the @prepare callback. Called with
- * 		prepare_lock held.
+ *		undo any work done in the @prepare callback. Called with
+ *		prepare_lock held.
  *
  * @is_prepared: Queries the hardware to determine if the clock is prepared.
  *		This function is allowed to sleep. Optional, if this op is not
@@ -58,16 +58,16 @@ struct dentry;
  *		Called with prepare mutex held. This function may sleep.
  *
  * @enable:	Enable the clock atomically. This must not return until the
- * 		clock is generating a valid clock signal, usable by consumer
- * 		devices. Called with enable_lock held. This function must not
- * 		sleep.
+ *		clock is generating a valid clock signal, usable by consumer
+ *		devices. Called with enable_lock held. This function must not
+ *		sleep.
  *
  * @disable:	Disable the clock atomically. Called with enable_lock held.
- * 		This function must not sleep.
+ *		This function must not sleep.
  *
  * @is_enabled:	Queries the hardware to determine if the clock is enabled.
- * 		This function must not sleep. Optional, if this op is not
- * 		set then the enable count will be used.
+ *		This function must not sleep. Optional, if this op is not
+ *		set then the enable count will be used.
  *
  * @disable_unused: Disable the clock atomically.  Only called from
  *		clk_disable_unused for gate clocks with special needs.
@@ -75,34 +75,34 @@ struct dentry;
  *		sleep.
  *
  * @recalc_rate	Recalculate the rate of this clock, by querying hardware. The
- * 		parent rate is an input parameter.  It is up to the caller to
- * 		ensure that the prepare_mutex is held across this call.
- * 		Returns the calculated rate.  Optional, but recommended - if
- * 		this op is not set then clock rate will be initialized to 0.
+ *		parent rate is an input parameter.  It is up to the caller to
+ *		ensure that the prepare_mutex is held across this call.
+ *		Returns the calculated rate.  Optional, but recommended - if
+ *		this op is not set then clock rate will be initialized to 0.
  *
  * @round_rate:	Given a target rate as input, returns the closest rate actually
- * 		supported by the clock.
+ *		supported by the clock.
  *
  * @determine_rate: Given a target rate as input, returns the closest rate
  *		actually supported by the clock, and optionally the parent clock
  *		that should be used to provide the clock rate.
  *
  * @get_parent:	Queries the hardware to determine the parent of a clock.  The
- * 		return value is a u8 which specifies the index corresponding to
- * 		the parent clock.  This index can be applied to either the
- * 		.parent_names or .parents arrays.  In short, this function
- * 		translates the parent value read from hardware into an array
- * 		index.  Currently only called when the clock is initialized by
- * 		__clk_init.  This callback is mandatory for clocks with
- * 		multiple parents.  It is optional (and unnecessary) for clocks
- * 		with 0 or 1 parents.
+ *		return value is a u8 which specifies the index corresponding to
+ *		the parent clock.  This index can be applied to either the
+ *		.parent_names or .parents arrays.  In short, this function
+ *		translates the parent value read from hardware into an array
+ *		index.  Currently only called when the clock is initialized by
+ *		__clk_init.  This callback is mandatory for clocks with
+ *		multiple parents.  It is optional (and unnecessary) for clocks
+ *		with 0 or 1 parents.
  *
  * @set_parent:	Change the input source of this clock; for clocks with multiple
- * 		possible parents specify a new parent by passing in the index
- * 		as a u8 corresponding to the parent in either the .parent_names
- * 		or .parents arrays.  This function in affect translates an
- * 		array index into the value programmed into the hardware.
- * 		Returns 0 on success, -EERROR otherwise.
+ *		possible parents specify a new parent by passing in the index
+ *		as a u8 corresponding to the parent in either the .parent_names
+ *		or .parents arrays.  This function in affect translates an
+ *		array index into the value programmed into the hardware.
+ *		Returns 0 on success, -EERROR otherwise.
  *
  * @set_rate:	Change the rate of this clock. The requested rate is specified
  *		by the second argument, which should typically be the return
@@ -254,12 +254,12 @@ void of_fixed_clk_setup(struct device_node *np);
  *
  * Flags:
  * CLK_GATE_SET_TO_DISABLE - by default this clock sets the bit at bit_idx to
- * 	enable the clock.  Setting this flag does the opposite: setting the bit
- * 	disable the clock and clearing it enables the clock
+ *	enable the clock.  Setting this flag does the opposite: setting the bit
+ *	disable the clock and clearing it enables the clock
  * CLK_GATE_HIWORD_MASK - The gate settings are only in lower 16-bit
- *   of this register, and mask of gate bits are in higher 16-bit of this
- *   register.  While setting the gate bits, higher 16-bit should also be
- *   updated to indicate changing gate bits.
+ *	of this register, and mask of gate bits are in higher 16-bit of this
+ *	register.  While setting the gate bits, higher 16-bit should also be
+ *	updated to indicate changing gate bits.
  */
 struct clk_gate {
 	struct clk_hw hw;
@@ -298,20 +298,20 @@ struct clk_div_table {
  *
  * Flags:
  * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
- * 	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
- * 	the raw value read from the register, with the value of zero considered
+ *	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
+ *	the raw value read from the register, with the value of zero considered
  *	invalid, unless CLK_DIVIDER_ALLOW_ZERO is set.
  * CLK_DIVIDER_POWER_OF_TWO - clock divisor is 2 raised to the value read from
- * 	the hardware register
+ *	the hardware register
  * CLK_DIVIDER_ALLOW_ZERO - Allow zero divisors.  For dividers which have
  *	CLK_DIVIDER_ONE_BASED set, it is possible to end up with a zero divisor.
  *	Some hardware implementations gracefully handle this case and allow a
  *	zero divisor by not modifying their input clock
  *	(divide by one / bypass).
  * CLK_DIVIDER_HIWORD_MASK - The divider settings are only in lower 16-bit
- *   of this register, and mask of divider bits are in higher 16-bit of this
- *   register.  While setting the divider bits, higher 16-bit should also be
- *   updated to indicate changing divider bits.
+ *	of this register, and mask of divider bits are in higher 16-bit of this
+ *	register.  While setting the divider bits, higher 16-bit should also be
+ *	updated to indicate changing divider bits.
  */
 struct clk_divider {
 	struct clk_hw	hw;
@@ -356,9 +356,9 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
  * CLK_MUX_INDEX_ONE - register index starts at 1, not 0
  * CLK_MUX_INDEX_BIT - register index is a single bit (power of two)
  * CLK_MUX_HIWORD_MASK - The mux settings are only in lower 16-bit of this
- *   register, and mask of mux bits are in higher 16-bit of this register.
- *   While setting the mux bits, higher 16-bit should also be updated to
- *   indicate changing mux bits.
+ *	register, and mask of mux bits are in higher 16-bit of this register.
+ *	While setting the mux bits, higher 16-bit should also be updated to
+ *	indicate changing mux bits.
  */
 struct clk_mux {
 	struct clk_hw	hw;
-- 
1.7.9.5

