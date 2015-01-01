Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbbAARSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:18:12 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:37765 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbAARSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:18:10 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: nwfpe: softfloat.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:21:10 +0100
Message-Id: <1420132870-32472-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
floatx80_lt_quiet() floatx80_le_quiet() floatx80_eq_signaling()
floatx80_le() floatx80_to_int32_round_to_zero() float64_lt_quiet()
float64_le_quiet() float64_eq_signaling() float32_lt_quiet()
float32_le_quiet() float32_eq_signaling()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/nwfpe/softfloat.c |  320 --------------------------------------------
 arch/arm/nwfpe/softfloat.h |   11 --
 2 files changed, 331 deletions(-)

diff --git a/arch/arm/nwfpe/softfloat.c b/arch/arm/nwfpe/softfloat.c
index ffa6b43..dda30ab 100644
--- a/arch/arm/nwfpe/softfloat.c
+++ b/arch/arm/nwfpe/softfloat.c
@@ -1568,78 +1568,6 @@ flag float32_lt( float32 a, float32 b )
 
 /*
 -------------------------------------------------------------------------------
-Returns 1 if the single-precision floating-point value `a' is equal to the
-corresponding value `b', and 0 otherwise.  The invalid exception is raised
-if either operand is a NaN.  Otherwise, the comparison is performed
-according to the IEC/IEEE Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag float32_eq_signaling( float32 a, float32 b )
-{
-
-    if (    ( ( extractFloat32Exp( a ) == 0xFF ) && extractFloat32Frac( a ) )
-         || ( ( extractFloat32Exp( b ) == 0xFF ) && extractFloat32Frac( b ) )
-       ) {
-        float_raise( float_flag_invalid );
-        return 0;
-    }
-    return ( a == b ) || ( (bits32) ( ( a | b )<<1 ) == 0 );
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns 1 if the single-precision floating-point value `a' is less than or
-equal to the corresponding value `b', and 0 otherwise.  Quiet NaNs do not
-cause an exception.  Otherwise, the comparison is performed according to the
-IEC/IEEE Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag float32_le_quiet( float32 a, float32 b )
-{
-    flag aSign, bSign;
-    //int16 aExp, bExp;
-
-    if (    ( ( extractFloat32Exp( a ) == 0xFF ) && extractFloat32Frac( a ) )
-         || ( ( extractFloat32Exp( b ) == 0xFF ) && extractFloat32Frac( b ) )
-       ) {
-        /* Do nothing, even if NaN as we're quiet */
-        return 0;
-    }
-    aSign = extractFloat32Sign( a );
-    bSign = extractFloat32Sign( b );
-    if ( aSign != bSign ) return aSign || ( (bits32) ( ( a | b )<<1 ) == 0 );
-    return ( a == b ) || ( aSign ^ ( a < b ) );
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns 1 if the single-precision floating-point value `a' is less than
-the corresponding value `b', and 0 otherwise.  Quiet NaNs do not cause an
-exception.  Otherwise, the comparison is performed according to the IEC/IEEE
-Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag float32_lt_quiet( float32 a, float32 b )
-{
-    flag aSign, bSign;
-
-    if (    ( ( extractFloat32Exp( a ) == 0xFF ) && extractFloat32Frac( a ) )
-         || ( ( extractFloat32Exp( b ) == 0xFF ) && extractFloat32Frac( b ) )
-       ) {
-        /* Do nothing, even if NaN as we're quiet */
-        return 0;
-    }
-    aSign = extractFloat32Sign( a );
-    bSign = extractFloat32Sign( b );
-    if ( aSign != bSign ) return aSign && ( (bits32) ( ( a | b )<<1 ) != 0 );
-    return ( a != b ) && ( aSign ^ ( a < b ) );
-
-}
-
-/*
--------------------------------------------------------------------------------
 Returns the result of converting the double-precision floating-point value
 `a' to the 32-bit two's complement integer format.  The conversion is
 performed according to the IEC/IEEE Standard for Binary Floating-point
@@ -2453,78 +2381,6 @@ flag float64_lt( float64 a, float64 b )
 
 }
 
-/*
--------------------------------------------------------------------------------
-Returns 1 if the double-precision floating-point value `a' is equal to the
-corresponding value `b', and 0 otherwise.  The invalid exception is raised
-if either operand is a NaN.  Otherwise, the comparison is performed
-according to the IEC/IEEE Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag float64_eq_signaling( float64 a, float64 b )
-{
-
-    if (    ( ( extractFloat64Exp( a ) == 0x7FF ) && extractFloat64Frac( a ) )
-         || ( ( extractFloat64Exp( b ) == 0x7FF ) && extractFloat64Frac( b ) )
-       ) {
-        float_raise( float_flag_invalid );
-        return 0;
-    }
-    return ( a == b ) || ( (bits64) ( ( a | b )<<1 ) == 0 );
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns 1 if the double-precision floating-point value `a' is less than or
-equal to the corresponding value `b', and 0 otherwise.  Quiet NaNs do not
-cause an exception.  Otherwise, the comparison is performed according to the
-IEC/IEEE Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag float64_le_quiet( float64 a, float64 b )
-{
-    flag aSign, bSign;
-    //int16 aExp, bExp;
-
-    if (    ( ( extractFloat64Exp( a ) == 0x7FF ) && extractFloat64Frac( a ) )
-         || ( ( extractFloat64Exp( b ) == 0x7FF ) && extractFloat64Frac( b ) )
-       ) {
-        /* Do nothing, even if NaN as we're quiet */
-        return 0;
-    }
-    aSign = extractFloat64Sign( a );
-    bSign = extractFloat64Sign( b );
-    if ( aSign != bSign ) return aSign || ( (bits64) ( ( a | b )<<1 ) == 0 );
-    return ( a == b ) || ( aSign ^ ( a < b ) );
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns 1 if the double-precision floating-point value `a' is less than
-the corresponding value `b', and 0 otherwise.  Quiet NaNs do not cause an
-exception.  Otherwise, the comparison is performed according to the IEC/IEEE
-Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag float64_lt_quiet( float64 a, float64 b )
-{
-    flag aSign, bSign;
-
-    if (    ( ( extractFloat64Exp( a ) == 0x7FF ) && extractFloat64Frac( a ) )
-         || ( ( extractFloat64Exp( b ) == 0x7FF ) && extractFloat64Frac( b ) )
-       ) {
-        /* Do nothing, even if NaN as we're quiet */
-        return 0;
-    }
-    aSign = extractFloat64Sign( a );
-    bSign = extractFloat64Sign( b );
-    if ( aSign != bSign ) return aSign && ( (bits64) ( ( a | b )<<1 ) != 0 );
-    return ( a != b ) && ( aSign ^ ( a < b ) );
-
-}
-
 #ifdef FLOATX80
 
 /*
@@ -2558,52 +2414,6 @@ int32 floatx80_to_int32( struct roundingData *roundData, floatx80 a )
 /*
 -------------------------------------------------------------------------------
 Returns the result of converting the extended double-precision floating-
-point value `a' to the 32-bit two's complement integer format.  The
-conversion is performed according to the IEC/IEEE Standard for Binary
-Floating-point Arithmetic, except that the conversion is always rounded
-toward zero.  If `a' is a NaN, the largest positive integer is returned.
-Otherwise, if the conversion overflows, the largest integer with the same
-sign as `a' is returned.
--------------------------------------------------------------------------------
-*/
-int32 floatx80_to_int32_round_to_zero( floatx80 a )
-{
-    flag aSign;
-    int32 aExp, shiftCount;
-    bits64 aSig, savedASig;
-    int32 z;
-
-    aSig = extractFloatx80Frac( a );
-    aExp = extractFloatx80Exp( a );
-    aSign = extractFloatx80Sign( a );
-    shiftCount = 0x403E - aExp;
-    if ( shiftCount < 32 ) {
-        if ( ( aExp == 0x7FFF ) && (bits64) ( aSig<<1 ) ) aSign = 0;
-        goto invalid;
-    }
-    else if ( 63 < shiftCount ) {
-        if ( aExp || aSig ) float_raise( float_flag_inexact );
-        return 0;
-    }
-    savedASig = aSig;
-    aSig >>= shiftCount;
-    z = aSig;
-    if ( aSign ) z = - z;
-    if ( ( z < 0 ) ^ aSign ) {
- invalid:
-        float_raise( float_flag_invalid );
-        return aSign ? 0x80000000 : 0x7FFFFFFF;
-    }
-    if ( ( aSig<<shiftCount ) != savedASig ) {
-        float_raise( float_flag_inexact );
-    }
-    return z;
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns the result of converting the extended double-precision floating-
 point value `a' to the single-precision floating-point format.  The
 conversion is performed according to the IEC/IEEE Standard for Binary
 Floating-point Arithmetic.
@@ -3270,40 +3080,6 @@ flag floatx80_eq( floatx80 a, floatx80 b )
 /*
 -------------------------------------------------------------------------------
 Returns 1 if the extended double-precision floating-point value `a' is
-less than or equal to the corresponding value `b', and 0 otherwise.  The
-comparison is performed according to the IEC/IEEE Standard for Binary
-Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag floatx80_le( floatx80 a, floatx80 b )
-{
-    flag aSign, bSign;
-
-    if (    (    ( extractFloatx80Exp( a ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( a )<<1 ) )
-         || (    ( extractFloatx80Exp( b ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( b )<<1 ) )
-       ) {
-        float_raise( float_flag_invalid );
-        return 0;
-    }
-    aSign = extractFloatx80Sign( a );
-    bSign = extractFloatx80Sign( b );
-    if ( aSign != bSign ) {
-        return
-               aSign
-            || (    ( ( (bits16) ( ( a.high | b.high )<<1 ) ) | a.low | b.low )
-                 == 0 );
-    }
-    return
-          aSign ? le128( b.high, b.low, a.high, a.low )
-        : le128( a.high, a.low, b.high, b.low );
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns 1 if the extended double-precision floating-point value `a' is
 less than the corresponding value `b', and 0 otherwise.  The comparison
 is performed according to the IEC/IEEE Standard for Binary Floating-point
 Arithmetic.
@@ -3335,101 +3111,5 @@ flag floatx80_lt( floatx80 a, floatx80 b )
 
 }
 
-/*
--------------------------------------------------------------------------------
-Returns 1 if the extended double-precision floating-point value `a' is equal
-to the corresponding value `b', and 0 otherwise.  The invalid exception is
-raised if either operand is a NaN.  Otherwise, the comparison is performed
-according to the IEC/IEEE Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag floatx80_eq_signaling( floatx80 a, floatx80 b )
-{
-
-    if (    (    ( extractFloatx80Exp( a ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( a )<<1 ) )
-         || (    ( extractFloatx80Exp( b ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( b )<<1 ) )
-       ) {
-        float_raise( float_flag_invalid );
-        return 0;
-    }
-    return
-           ( a.low == b.low )
-        && (    ( a.high == b.high )
-             || (    ( a.low == 0 )
-                  && ( (bits16) ( ( a.high | b.high )<<1 ) == 0 ) )
-           );
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns 1 if the extended double-precision floating-point value `a' is less
-than or equal to the corresponding value `b', and 0 otherwise.  Quiet NaNs
-do not cause an exception.  Otherwise, the comparison is performed according
-to the IEC/IEEE Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag floatx80_le_quiet( floatx80 a, floatx80 b )
-{
-    flag aSign, bSign;
-
-    if (    (    ( extractFloatx80Exp( a ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( a )<<1 ) )
-         || (    ( extractFloatx80Exp( b ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( b )<<1 ) )
-       ) {
-        /* Do nothing, even if NaN as we're quiet */
-        return 0;
-    }
-    aSign = extractFloatx80Sign( a );
-    bSign = extractFloatx80Sign( b );
-    if ( aSign != bSign ) {
-        return
-               aSign
-            || (    ( ( (bits16) ( ( a.high | b.high )<<1 ) ) | a.low | b.low )
-                 == 0 );
-    }
-    return
-          aSign ? le128( b.high, b.low, a.high, a.low )
-        : le128( a.high, a.low, b.high, b.low );
-
-}
-
-/*
--------------------------------------------------------------------------------
-Returns 1 if the extended double-precision floating-point value `a' is less
-than the corresponding value `b', and 0 otherwise.  Quiet NaNs do not cause
-an exception.  Otherwise, the comparison is performed according to the
-IEC/IEEE Standard for Binary Floating-point Arithmetic.
--------------------------------------------------------------------------------
-*/
-flag floatx80_lt_quiet( floatx80 a, floatx80 b )
-{
-    flag aSign, bSign;
-
-    if (    (    ( extractFloatx80Exp( a ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( a )<<1 ) )
-         || (    ( extractFloatx80Exp( b ) == 0x7FFF )
-              && (bits64) ( extractFloatx80Frac( b )<<1 ) )
-       ) {
-        /* Do nothing, even if NaN as we're quiet */
-        return 0;
-    }
-    aSign = extractFloatx80Sign( a );
-    bSign = extractFloatx80Sign( b );
-    if ( aSign != bSign ) {
-        return
-               aSign
-            && (    ( ( (bits16) ( ( a.high | b.high )<<1 ) ) | a.low | b.low )
-                 != 0 );
-    }
-    return
-          aSign ? lt128( b.high, b.low, a.high, a.low )
-        : lt128( a.high, a.low, b.high, b.low );
-
-}
-
 #endif
 
diff --git a/arch/arm/nwfpe/softfloat.h b/arch/arm/nwfpe/softfloat.h
index df4d243..8a5b2b2 100644
--- a/arch/arm/nwfpe/softfloat.h
+++ b/arch/arm/nwfpe/softfloat.h
@@ -157,9 +157,6 @@ float32 float32_sqrt( struct roundingData*, float32 );
 char float32_eq( float32, float32 );
 char float32_le( float32, float32 );
 char float32_lt( float32, float32 );
-char float32_eq_signaling( float32, float32 );
-char float32_le_quiet( float32, float32 );
-char float32_lt_quiet( float32, float32 );
 char float32_is_signaling_nan( float32 );
 
 /*
@@ -189,9 +186,6 @@ float64 float64_sqrt( struct roundingData *, float64 );
 char float64_eq( float64, float64 );
 char float64_le( float64, float64 );
 char float64_lt( float64, float64 );
-char float64_eq_signaling( float64, float64 );
-char float64_le_quiet( float64, float64 );
-char float64_lt_quiet( float64, float64 );
 char float64_is_signaling_nan( float64 );
 
 #ifdef FLOATX80
@@ -202,7 +196,6 @@ Software IEC/IEEE extended double-precision conversion routines.
 -------------------------------------------------------------------------------
 */
 signed int floatx80_to_int32( struct roundingData *, floatx80 );
-signed int floatx80_to_int32_round_to_zero( floatx80 );
 float32 floatx80_to_float32( struct roundingData *, floatx80 );
 float64 floatx80_to_float64( struct roundingData *, floatx80 );
 
@@ -219,11 +212,7 @@ floatx80 floatx80_div( struct roundingData *, floatx80, floatx80 );
 floatx80 floatx80_rem( struct roundingData *, floatx80, floatx80 );
 floatx80 floatx80_sqrt( struct roundingData *, floatx80 );
 char floatx80_eq( floatx80, floatx80 );
-char floatx80_le( floatx80, floatx80 );
 char floatx80_lt( floatx80, floatx80 );
-char floatx80_eq_signaling( floatx80, floatx80 );
-char floatx80_le_quiet( floatx80, floatx80 );
-char floatx80_lt_quiet( floatx80, floatx80 );
 char floatx80_is_signaling_nan( floatx80 );
 
 extern flag floatx80_is_nan(floatx80);
-- 
1.7.10.4

