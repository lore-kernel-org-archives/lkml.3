Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaKFW4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:56:36 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48466 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaKFW4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:56:32 -0500
From: kris@konagma.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: navin.patidar@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kris@konagma.com
Subject: [PATCH] rtl8188eu: Fix several stylistic problems in rtw_led.*
Date: Thu,  6 Nov 2014 23:56:05 +0100
Message-Id: <1415314565-9552-1-git-send-email-kris@konagma.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Konopko <kris@konagma.com>

Several stylistics problems are reported by scripts/checkpatch.pl run on
rtw_led.*:

  * FSF_MAILING_ADDRESS

    Free Software Foundation's mailing address should not be included in
    the sample GPL notice.

  * LINE_SPACING

    Missing a blank line after declarations.

  * leading spaces

  * a typo

  * any too long lines changed with this patch

All of the problems above are fixed with this patch.

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8188eu/core/rtw_led.c    | 15 +++++++--------
 drivers/staging/rtl8188eu/include/rtw_led.h |  6 +-----
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
index 2aa6251..5d7e8ec 100644
--- a/drivers/staging/rtl8188eu/core/rtw_led.c
+++ b/drivers/staging/rtl8188eu/core/rtw_led.c
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  *
  ******************************************************************************/
 
@@ -44,6 +40,7 @@ void BlinkTimerCallback(void *data)
 void BlinkWorkItemCallback(struct work_struct *work)
 {
 	struct LED_871x *pLed = container_of(work, struct LED_871x, BlinkWorkItem);
+
 	BlinkHandler(pLed);
 }
 
@@ -228,7 +225,8 @@ static void SwLedBlink1(struct LED_871x *pLed)
 			pLed->bLedWPSBlinkInProgress = false;
 		} else {
 			pLed->BlinkingLedState = RTW_LED_OFF;
-			_set_timer(&(pLed->BlinkTimer), LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA);
+			_set_timer(&(pLed->BlinkTimer),
+				   LED_BLINK_WPS_SUCCESS_INTERVAL_ALPHA);
 		}
 		break;
 	default:
@@ -392,7 +390,8 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 		pLed->CurrLedState = LED_BLINK_WPS_STOP;
 		if (pLed->bLedOn) {
 			pLed->BlinkingLedState = RTW_LED_OFF;
-			_set_timer(&(pLed->BlinkTimer), LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA);
+			_set_timer(&(pLed->BlinkTimer),
+				   LED_BLINK_WPS_SUCCESS_INTERVAL_ALPHA);
 		} else {
 			pLed->BlinkingLedState = RTW_LED_ON;
 			_set_timer(&(pLed->BlinkTimer), 0);
@@ -461,8 +460,8 @@ void LedControl8188eu(struct adapter *padapter, enum LED_CTL_MODE LedAction)
 {
 	struct led_priv *ledpriv = &(padapter->ledpriv);
 
-       if ((padapter->bSurpriseRemoved) || (padapter->bDriverStopped) ||
-	   (!padapter->hw_init_completed))
+	if ((padapter->bSurpriseRemoved) || (padapter->bDriverStopped) ||
+	    (!padapter->hw_init_completed))
 		return;
 
 	if (!ledpriv->bRegUseLed)
diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index dec8dbc..23f0cfe 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  *
  ******************************************************************************/
 #ifndef __RTW_LED_H_
@@ -27,7 +23,7 @@
 #define LED_BLINK_LINK_INTERVAL_ALPHA		500	/* 500 */
 #define LED_BLINK_SCAN_INTERVAL_ALPHA		180	/* 150 */
 #define LED_BLINK_FASTER_INTERVAL_ALPHA		50
-#define LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA	5000
+#define LED_BLINK_WPS_SUCCESS_INTERVAL_ALPHA	5000
 
 enum LED_CTL_MODE {
 	LED_CTL_POWER_ON,
-- 
2.1.1

