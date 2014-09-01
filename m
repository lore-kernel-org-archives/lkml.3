Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaIADii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:38:38 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45724 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaIADih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:38:37 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/4] staging: comedi: hwdrv_apci1500: clean some whitespace style issues
Date: Sun, 31 Aug 2014 22:38:26 -0500
Message-Id: <7ec7d10f2dc958d4eede615f07c8b1abeb0715f5.1409542016.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409542016.git.chase.southwood@gmail.com>
References: <cover.1409542016.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that commented out code has been removed, else statements can move to
the same line as the close brace of the if statement.  Also, a blank line
has been added between declarations and code where needed.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 139 ++++++++-------------
 1 file changed, 49 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 031882e..d98636b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -172,12 +172,10 @@ static int apci1500_di_config(struct comedi_device *dev,
 
 	if (data[0] == 1) {
 		i_MaxChannel = 8;
-	}
-	else {
+	} else {
 		if (data[0] == 2) {
 			i_MaxChannel = 6;
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"The specified port event does not exist\n");
 			return -EINVAL;
@@ -347,8 +345,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
@@ -448,8 +445,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 			outb(0xF4,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
@@ -518,8 +514,7 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
-				}
-				else {
+				} else {
 					dev_warn(dev->hw_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
@@ -555,15 +550,13 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 1;
-				}
-				else {
+				} else {
 					dev_warn(dev->hw_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
 				}
 			}
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
@@ -600,8 +593,7 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event1InterruptStatus = 0;
-				}
-				else {
+				} else {
 					dev_warn(dev->hw_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
@@ -630,16 +622,15 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 0;
-				}
-				else {
+				} else {
+
 					dev_warn(dev->hw_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
 				}
 			}
 
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
@@ -843,8 +834,7 @@ static int apci1500_do_write(struct comedi_device *dev,
 			data[0] = (data[0] << ui_NoOfChannel) | ui_Temp;
 			outw(data[0],
 				devpriv->i_IobaseAddon + APCI1500_DIGITAL_OP);
-		}
-		else {
+		} else {
 			if (data[1] == 1) {
 				switch (ui_NoOfChannel) {
 
@@ -880,15 +870,13 @@ static int apci1500_do_write(struct comedi_device *dev,
 				outw(data[0],
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Specified channel not supported\n");
 				return -EINVAL;
 			}
 		}
-	}
-	else {
+	} else {
 		if (data[3] == 1) {
 			if (data[1] == 0) {
 				data[0] = ~data[0] & 0x1;
@@ -902,8 +890,7 @@ static int apci1500_do_write(struct comedi_device *dev,
 				outw(data[0],
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
-			}
-			else {
+			} else {
 				if (data[1] == 1) {
 					switch (ui_NoOfChannel) {
 
@@ -959,15 +946,13 @@ static int apci1500_do_write(struct comedi_device *dev,
 					outw(data[0],
 						devpriv->i_IobaseAddon +
 						APCI1500_DIGITAL_OP);
-				}
-				else {
+				} else {
 					dev_warn(dev->hw_dev,
 						"Specified channel not supported\n");
 					return -EINVAL;
 				}
 			}
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"Specified functionality does not exist\n");
 			return -EINVAL;
@@ -1004,8 +989,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 /* Selection of the input clock */
 	if (data[0] == 0 || data[0] == 1 || data[0] == 2) {
 		outw(data[0], devpriv->i_IobaseAddon + APCI1500_CLK_SELECT);
-	}
-	else {
+	} else {
 		if (data[0] != 3) {
 			dev_warn(dev->hw_dev,
 				"The option for input clock selection does not exist\n");
@@ -1132,14 +1116,12 @@ static int apci1500_timer_config(struct comedi_device *dev,
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
@@ -1294,14 +1276,12 @@ static int apci1500_timer_config(struct comedi_device *dev,
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
@@ -1359,8 +1339,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			/* - Enables retrigger       */
 			/* - Pulses output           */
 			i_TimerCounterMode = data[2] | data[4] | 0x54;
-		}
-		else {
+		} else {
 			i_TimerCounterMode = data[2] | data[4] | data[6] | 7;
 		}
 		/* Test the reload value */
@@ -1456,14 +1435,13 @@ static int apci1500_timer_config(struct comedi_device *dev,
 
 				}
 
-			}
-			else {
+			} else {
+
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
@@ -1515,8 +1493,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer1 not configured\n");
 				return -EINVAL;
@@ -1543,8 +1520,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					/* Set Trigger and gate */
 
 					i_CommandAndStatusValue = 0x6;
-				}
-				else {
+				} else {
 					/* Set Trigger */
 
 					i_CommandAndStatusValue = 0x2;
@@ -1557,8 +1533,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer1 not configured\n");
 				return -EINVAL;
@@ -1590,8 +1565,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer2 not configured\n");
 				return -EINVAL;
@@ -1617,8 +1591,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					/* Set Trigger and gate */
 
 					i_CommandAndStatusValue = 0x6;
-				}
-				else {
+				} else {
 					/* Set Trigger */
 
 					i_CommandAndStatusValue = 0x2;
@@ -1631,8 +1604,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer2 not configured\n");
 				return -EINVAL;
@@ -1664,8 +1636,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-			}
-			else {
+			} else {
 				dev_warn(dev->hw_dev,
 					"Watchdog/Counter3 not configured\n");
 				return -EINVAL;
@@ -1694,8 +1665,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 						/* Set Trigger and gate */
 
 						i_CommandAndStatusValue = 0x6;
-					}
-					else {
+					} else {
 						/* Set Trigger */
 
 						i_CommandAndStatusValue = 0x2;
@@ -1708,8 +1678,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					outb(i_CommandAndStatusValue,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-				}
-				else {
+				} else {
 					dev_warn(dev->hw_dev,
 						"Counter3 not configured\n");
 					return -EINVAL;
@@ -1726,8 +1695,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					outb(0x6,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-				}
-				else {
+				} else {
 					dev_warn(dev->hw_dev,
 						"Watchdog 3 not configured\n");
 					return -EINVAL;
@@ -1774,8 +1742,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				/* Set RCC and gate */
 
 				i_CommandAndStatusValue = 0xC;
-			}
-			else {
+			} else {
 				/* Set RCC */
 
 				i_CommandAndStatusValue = 0x8;
@@ -1804,8 +1771,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"Timer/Counter1 not configured\n");
 			return -EINVAL;
@@ -1818,8 +1784,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				/* Set RCC and gate */
 
 				i_CommandAndStatusValue = 0xC;
-			}
-			else {
+			} else {
 				/* Set RCC */
 
 				i_CommandAndStatusValue = 0x8;
@@ -1848,8 +1813,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		}		/* if( i_TimerCounter2Init==1) */
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"Timer/Counter2 not configured\n");
 			return -EINVAL;
@@ -1862,8 +1826,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				/* Set RCC and gate */
 
 				i_CommandAndStatusValue = 0xC;
-			}
-			else {
+			} else {
 				/* Set RCC */
 
 				i_CommandAndStatusValue = 0x8;
@@ -1892,8 +1855,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"WatchdogCounter3 not configured\n");
 			return -EINVAL;
@@ -1942,12 +1904,10 @@ static int apci1500_do_bits(struct comedi_device *dev,
 	outl(0x0, devpriv->i_IobaseAmcc + 0x38);
 	if (data[0] == 1) {
 		i_Constant = 0xC0;
-	}
-	else {
+	} else {
 		if (data[0] == 0) {
 			i_Constant = 0x00;
-		}
-		else {
+		} else {
 			dev_warn(dev->hw_dev,
 				"The parameter passed to driver is in error for enabling the voltage interrupt\n");
 			return -EINVAL;
@@ -2058,6 +2018,8 @@ static void apci1500_interrupt(int irq, void *d)
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_InterruptStatus = 0;
 	int i_RegValue = 0;
+
+	/* Clear the interrupt mask */
 	i_InterruptMask = 0;
 
 	/* Read the board interrupt status */
@@ -2102,8 +2064,7 @@ static void apci1500_interrupt(int irq, void *d)
 
 				i_InputChannel = 1 + (i_RegValue >> 1);
 
-			}
-			else {
+			} else {
 				i_InputChannel = 0;
 			}
 		}
@@ -2145,8 +2106,7 @@ static void apci1500_interrupt(int irq, void *d)
 					i_InterruptMask =
 						i_InterruptMask | 0x80;
 				}
-			}
-			else {
+			} else {
 				i_InterruptMask = i_InterruptMask | 2;
 			}
 		}
@@ -2215,8 +2175,7 @@ static void apci1500_interrupt(int irq, void *d)
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		/* Authorizes the main interrupt on the board */
 		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	}
-	else {
+	} else {
 		dev_warn(dev->hw_dev,
 			"Interrupt from unknown source\n");
 
-- 
2.1.0

