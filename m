Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935136AbaICX7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:59:19 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45839 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbaICX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:59:17 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: hwdrv_apci1500: use dev->class_dev in calls to dev_warn()
Date: Wed,  3 Sep 2014 18:58:49 -0500
Message-Id: <1409788729-22875-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git-grep reveals that hwdrv_apci1500.c is the only file in comedi that uses
dev->hw_dev in calls to dev_{err,warn}().  The rest of the drivers pass
dev->class_dev to these macros instead.  Switch the dev_warn() calls in
this driver to use dev->class_dev as well, for consistency.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
As an aside, it looks like lots of these cases are actually error
conditions that might be more appropriate use cases for dev_err().  But
they could be changed in a follow on patch, this is enough for this one.
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 104 ++++++++++-----------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index e637be1..0ea081e 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -176,7 +176,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 		if (data[0] == 2) {
 			i_MaxChannel = 6;
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The specified port event does not exist\n");
 			return -EINVAL;
 		}
@@ -192,7 +192,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 		data[1] = APCI1500_OR_PRIORITY;
 		break;
 	default:
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"The specified interrupt logic does not exist\n");
 		return -EINVAL;
 	}
@@ -237,7 +237,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 		case 5:
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The option indicated in the event mask does not exist\n");
 			return -EINVAL;
 		}
@@ -254,7 +254,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 
 			if (data[1] == APCI1500_OR_PRIORITY
 				&& i_PatternTransition != 0) {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Transition error on an OR PRIORITY logic\n");
 				return -EINVAL;
 			}
@@ -272,7 +272,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 				}
 
 				if (i_PatternTransitionCount > 1) {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Transition error on an AND logic\n");
 					return -EINVAL;
 				}
@@ -346,7 +346,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 				APCI1500_Z8536_CONTROL_REGISTER);
 
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}
@@ -446,7 +446,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}
@@ -515,7 +515,7 @@ static int apci1500_di_write(struct comedi_device *dev,
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 				} else {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
 				}
@@ -551,13 +551,13 @@ static int apci1500_di_write(struct comedi_device *dev,
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 1;
 				} else {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
 				}
 			}
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
 		}
@@ -594,7 +594,7 @@ static int apci1500_di_write(struct comedi_device *dev,
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event1InterruptStatus = 0;
 				} else {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
 				}
@@ -624,20 +624,20 @@ static int apci1500_di_write(struct comedi_device *dev,
 					i_Event2InterruptStatus = 0;
 				} else {
 
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
 				}
 			}
 
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
@@ -871,7 +871,7 @@ static int apci1500_do_write(struct comedi_device *dev,
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Specified channel not supported\n");
 				return -EINVAL;
 			}
@@ -947,13 +947,13 @@ static int apci1500_do_write(struct comedi_device *dev,
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
@@ -991,7 +991,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 		outw(data[0], devpriv->i_IobaseAddon + APCI1500_CLK_SELECT);
 	} else {
 		if (data[0] != 3) {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The option for input clock selection does not exist\n");
 			return -EINVAL;
 		}
@@ -1008,7 +1008,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[2] = APCI1500_TIMER;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
 		}
@@ -1022,7 +1022,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}
@@ -1117,12 +1117,12 @@ static int apci1500_timer_config(struct comedi_device *dev,
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
@@ -1139,7 +1139,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[2] = APCI1500_TIMER;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
 		}
@@ -1153,7 +1153,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}
@@ -1167,7 +1167,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[5] = APCI1500_HARDWARE_TRIGGER;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice for software or hardware trigger does not exist\n");
 			return -EINVAL;
 		}
@@ -1181,7 +1181,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}
@@ -1277,12 +1277,12 @@ static int apci1500_timer_config(struct comedi_device *dev,
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
@@ -1299,7 +1299,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[2] = APCI1500_WATCHDOG;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice is not a watchdog nor a counter\n");
 			return -EINVAL;
 		}
@@ -1313,7 +1313,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}
@@ -1327,7 +1327,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}
@@ -1437,12 +1437,12 @@ static int apci1500_timer_config(struct comedi_device *dev,
 
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
@@ -1451,7 +1451,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 		break;
 
 	default:
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"The specified counter/timer option does not exist\n");
 		return -EINVAL;
 	}
@@ -1494,7 +1494,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Counter/Timer1 not configured\n");
 				return -EINVAL;
 			}
@@ -1534,14 +1534,14 @@ static int apci1500_timer_write(struct comedi_device *dev,
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
@@ -1566,7 +1566,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Counter/Timer2 not configured\n");
 				return -EINVAL;
 			}
@@ -1605,13 +1605,13 @@ static int apci1500_timer_write(struct comedi_device *dev,
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
@@ -1637,7 +1637,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					APCI1500_Z8536_CONTROL_REGISTER);
 
 			} else {
-				dev_warn(dev->hw_dev,
+				dev_warn(dev->class_dev,
 					"Watchdog/Counter3 not configured\n");
 				return -EINVAL;
 			}
@@ -1679,7 +1679,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 				} else {
-					dev_warn(dev->hw_dev,
+					dev_warn(dev->class_dev,
 						"Counter3 not configured\n");
 					return -EINVAL;
 				}
@@ -1696,25 +1696,25 @@ static int apci1500_timer_write(struct comedi_device *dev,
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
@@ -1772,7 +1772,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Timer/Counter1 not configured\n");
 			return -EINVAL;
 		}
@@ -1814,7 +1814,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"Timer/Counter2 not configured\n");
 			return -EINVAL;
 		}
@@ -1856,13 +1856,13 @@ static int apci1500_timer_bits(struct comedi_device *dev,
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
@@ -1908,7 +1908,7 @@ static int apci1500_do_bits(struct comedi_device *dev,
 		if (data[0] == 0) {
 			i_Constant = 0x00;
 		} else {
-			dev_warn(dev->hw_dev,
+			dev_warn(dev->class_dev,
 				"The parameter passed to driver is in error for enabling the voltage interrupt\n");
 			return -EINVAL;
 		}
@@ -2176,7 +2176,7 @@ static void apci1500_interrupt(int irq, void *d)
 		/* Authorizes the main interrupt on the board */
 		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	} else {
-		dev_warn(dev->hw_dev,
+		dev_warn(dev->class_dev,
 			"Interrupt from unknown source\n");
 
 	}
-- 
2.1.0

