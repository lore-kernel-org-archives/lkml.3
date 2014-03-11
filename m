Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaCKO6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:58:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51582 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaCKO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:58:33 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Meyer <cse.cem@gmail.com>
Subject: [PATCH] Staging: comedi: fixup: dev_warn() with correct dev
Date: Tue, 11 Mar 2014 07:58:17 -0700
Message-Id: <1394549897-15186-1-git-send-email-cse.cem@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <531F1B76.6010608@mev.co.uk>
References: <531F1B76.6010608@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace hw_dev with class_dev in new dev_warn()s.

Sending this as a patch on top of the one already applied, since GregKH already
took that one. If this is the wrong way to fix it, please let me know how I
should proceed, I'm new.

Thanks!

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 104 ++++++++++-----------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index cdc6d3d..2f71dd0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -253,7 +253,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 		if (data[0] == 2) {
 			i_MaxChannel = 6;
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The specified port event does not exist\n");
 			return -EINVAL;
 		}
@@ -270,7 +270,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 		data[1] = APCI1500_OR_PRIORITY;
 		break;
 	default:
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"The specified interrupt logic does not exist\n");
 		return -EINVAL;
 	}
@@ -315,7 +315,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 		case 5:
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The option indicated in the event mask does not exist\n");
 			return -EINVAL;
 		}
@@ -326,7 +326,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 
 		if (data[1] != APCI1500_AND && data[1] != APCI1500_OR &&
 			data[1] != APCI1500_OR_PRIORITY) {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}
@@ -336,7 +336,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 
 		if (data[1] == APCI1500_OR_PRIORITY
 			&& i_PatternTransition != 0) {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Transition error on an OR PRIORITY logic\n");
 			return -EINVAL;
 		}
@@ -354,7 +354,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 			}
 
 			if (i_PatternTransitionCount > 1) {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Transition error on an AND logic\n");
 				return -EINVAL;
 			}
@@ -434,7 +434,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 		/* Test the event logic */
 
 		if (data[1] != APCI1500_OR) {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}
@@ -568,7 +568,7 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 		if (data[1] == 1) {
 			/* Test if event initialised */
 			if (i_Event1Status != 1) {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Event 1 not initialised\n");
 				return -EINVAL;
 			}
@@ -609,7 +609,7 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 		} else if (data[1] == 2) {
 
 			if (i_Event2Status != 1) {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Event 2 not initialised\n");
 				return -EINVAL;
 			}
@@ -642,7 +642,7 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_Event2InterruptStatus = 1;
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
 		}
@@ -655,7 +655,7 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 		if (data[1] == 1) {
 			/* Test if event initialised */
 			if (i_Event1Status != 1) {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Event 1 not initialised\n");
 				return -EINVAL;
 			}
@@ -683,7 +683,7 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 		} else if (data[1] == 2) {
 			/* Test if event initialised */
 			if (i_Event2Status != 1) {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Event 2 not initialised\n");
 				return -EINVAL;
 			}
@@ -709,13 +709,13 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_Event2InterruptStatus = 0;
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
 		}
 		break;
 	default:
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"The option of START/STOP logic does not exist\n");
 		return -EINVAL;
 	}
@@ -995,7 +995,7 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Specified channel not supported\n");
 				return -EINVAL;
 			}
@@ -1065,13 +1065,13 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 						devpriv->i_IobaseAddon +
 						APCI1500_DIGITAL_OP);
 				} else {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Specified channel not supported\n");
 					return -EINVAL;
 				}
 			}
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Specified functionality does not exist\n");
 			return -EINVAL;
 		}
@@ -1144,7 +1144,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 		outw(data[0], devpriv->i_IobaseAddon + APCI1500_CLK_SELECT);
 	} else {
 		if (data[0] != 3) {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The option for input clock selection does not exist\n");
 			return -EINVAL;
 		}
@@ -1162,7 +1162,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[2] = APCI1500_TIMER;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
 		}
@@ -1176,7 +1176,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}
@@ -1271,12 +1271,12 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
 		}
@@ -1293,7 +1293,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[2] = APCI1500_TIMER;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
 		}
@@ -1307,7 +1307,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}
@@ -1321,7 +1321,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[5] = APCI1500_HARDWARE_TRIGGER;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice for software or hardware trigger does not exist\n");
 			return -EINVAL;
 		}
@@ -1335,7 +1335,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}
@@ -1431,12 +1431,12 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
 		}
@@ -1453,7 +1453,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[2] = APCI1500_WATCHDOG;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice is not a watchdog nor a counter\n");
 			return -EINVAL;
 		}
@@ -1467,7 +1467,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}
@@ -1481,7 +1481,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}
@@ -1590,12 +1590,12 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 				}
 
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
 		}
@@ -1604,7 +1604,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 		break;
 
 	default:
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"The specified counter/timer option does not exist\n");
 		return -EINVAL;
 	}
@@ -1666,7 +1666,7 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Counter/Timer1 not configured\n");
 				return -EINVAL;
 			}
@@ -1705,14 +1705,14 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Counter/Timer1 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}
@@ -1736,7 +1736,7 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Counter/Timer2 not configured\n");
 				return -EINVAL;
 			}
@@ -1772,13 +1772,13 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Counter/Timer2 not configured\n");
 				return -EINVAL;
 			}
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}
@@ -1803,7 +1803,7 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 					APCI1500_Z8536_CONTROL_REGISTER);
 
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Watchdog/Counter3 not configured\n");
 				return -EINVAL;
 			}
@@ -1842,7 +1842,7 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 				} else {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Counter3 not configured\n");
 					return -EINVAL;
 				}
@@ -1858,25 +1858,25 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 				} else {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Watchdog 3 not configured\n");
 					return -EINVAL;
 				}
 				break;
 			default:
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Wrong choice of watchdog/counter3\n");
 				return -EINVAL;
 			}
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}
 		break;
 	default:
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"The specified choice for counter/watchdog/timer does not exist\n");
 		return -EINVAL;
 	}
@@ -1950,7 +1950,7 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Timer/Counter1 not configured\n");
 			return -EINVAL;
 		}
@@ -1989,7 +1989,7 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Timer/Counter2 not configured\n");
 			return -EINVAL;
 		}
@@ -2028,13 +2028,13 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"WatchdogCounter3 not configured\n");
 			return -EINVAL;
 		}
 		break;
 	default:
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"The choice of timer/counter/watchdog does not exist\n");
 		return -EINVAL;
 	}
@@ -2115,7 +2115,7 @@ static int i_APCI1500_ConfigureInterrupt(struct comedi_device *dev,
 		if (data[0] == 0) {
 			i_Constant = 0x00;
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The parameter passed to driver is in error for enabling the voltage interrupt\n");
 			return -EINVAL;
 		}
@@ -2401,7 +2401,7 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 		/* Authorizes the main interrupt on the board */
 		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	} else {
-		dev_warn(dev->hw_dev, "Interrupt from unknown source\n");
+		dev_warn(dev->class_dev, "Interrupt from unknown source\n");
 	}
 	return;
 }
-- 
1.8.5.3

